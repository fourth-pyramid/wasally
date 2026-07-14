import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart' as fb;

/// A mixin to protect Blocs from `StateError (Bad state: Cannot emit new states after calling close)`
/// and automatically cancel pending HTTP requests associated with this Bloc.
mixin SafeBlocMixin<Event, BlocState> on fb.Bloc<Event, BlocState> {
  late final Object _blocCancelKey = hashCode;

  @override
  void on<E extends Event>(
    fb.EventHandler<E, BlocState> handler, {
    fb.EventTransformer<E>? transformer,
  }) {
    super.on<E>(
      (event, emit) async {
        if (isClosed) return;
        final safeEmitter = _SafeEmitter<BlocState>(emit, this);

        // Run the event handler inside a Zone carrying the Bloc's unique cancel key.
        // CancelTokenInterceptor will automatically extract this key and associate
        // any HTTP requests initiated under this block to a CancelToken for this Bloc.
        await runZoned(
          () async {
            await handler(event, safeEmitter);
          },
          zoneValues: {#blocCancelKey: _blocCancelKey},
        );
      },
      transformer: transformer,
    );
  }

  @override
  Future<void> close() {
    // Automatically cancel all pending HTTP requests linked to this Bloc when closed.
    if (sl.isRegistered<CancelRequestService>()) {
      sl<CancelRequestService>().cancel(
        _blocCancelKey,
        reason: 'Bloc "$runtimeType" (hashCode: $_blocCancelKey) closed',
      );
    }
    return super.close();
  }
}

/// A mixin to protect Cubits from `StateError (Bad state: Cannot emit new states after calling close)`
/// and automatically cancel pending HTTP requests associated with this Cubit.
mixin SafeCubitMixin<BlocState> on fb.Cubit<BlocState> {
  late final Object _cubitCancelKey = hashCode;

  @override
  void emit(BlocState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  /// Runs a function inside a [Zone] carrying this Cubit's unique cancel key.
  ///
  /// Use this wrapper for asynchronous operations in Cubit methods to ensure automatic
  /// request cancellation upon close:
  /// ```dart
  /// Future<void> loadData() => runSafeAsync(() async {
  ///   final data = await repository.getData();
  ///   emit(Success(data));
  /// });
  /// ```
  Future<T> runSafeAsync<T>(Future<T> Function() computation) => runZoned(
        computation,
        zoneValues: {#blocCancelKey: _cubitCancelKey},
      );

  @override
  Future<void> close() {
    // Automatically cancel all pending HTTP requests linked to this Cubit when closed.
    if (sl.isRegistered<CancelRequestService>()) {
      sl<CancelRequestService>().cancel(
        _cubitCancelKey,
        reason: 'Cubit "$runtimeType" (hashCode: $_cubitCancelKey) closed',
      );
    }
    return super.close();
  }
}

/// A safe base Bloc class that prevents the StateError on emit.
abstract class Bloc<Event, BlocState> extends fb.Bloc<Event, BlocState> with SafeBlocMixin<Event, BlocState> {
  Bloc(super.initialState);
}

/// A safe base Cubit class that prevents the StateError on emit.
abstract class Cubit<BlocState> extends fb.Cubit<BlocState> with SafeCubitMixin<BlocState> {
  Cubit(super.initialState);
}

class _SafeEmitter<BlocState> implements Emitter<BlocState> {
  final Emitter<BlocState> _delegate;
  final fb.BlocBase<BlocState> _bloc;

  _SafeEmitter(this._delegate, this._bloc);

  @override
  void call(BlocState state) {
    if (!_delegate.isDone && !_bloc.isClosed) {
      _delegate(state);
    }
  }

  @override
  Future<void> forEach<T>(
    Stream<T> stream, {
    required BlocState Function(T data) onData,
    BlocState Function(Object error, StackTrace stackTrace)? onError,
  }) =>
      _delegate.forEach(
        stream,
        onData: onData,
        onError: onError,
      );

  @override
  bool get isDone => _delegate.isDone || _bloc.isClosed;

  @override
  Future<void> onEach<T>(
    Stream<T> stream, {
    required void Function(T data) onData,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) =>
      _delegate.onEach(
        stream,
        onData: onData,
        onError: onError,
      );
}
