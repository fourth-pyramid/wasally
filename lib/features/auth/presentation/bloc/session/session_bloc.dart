import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/auth/domain/usecases/clear_user_session_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/get_saved_token_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/login_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/logout_usecase.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final LoginUseCase _loginUseCase;
  final GetSavedTokenUseCase _getSavedTokenUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final GetCachedUserUseCase _getCachedUserUseCase;
  final LogoutUseCase _logoutUseCase;
  final ClearUserSessionUseCase _clearUserSessionUseCase;

  SessionBloc({
    required LoginUseCase loginUseCase,
    required GetSavedTokenUseCase getSavedTokenUseCase,
    required GetProfileUseCase getProfileUseCase,
    required GetCachedUserUseCase getCachedUserUseCase,
    required LogoutUseCase logoutUseCase,
    required ClearUserSessionUseCase clearUserSessionUseCase,
  })  : _loginUseCase = loginUseCase,
        _getSavedTokenUseCase = getSavedTokenUseCase,
        _getProfileUseCase = getProfileUseCase,
        _getCachedUserUseCase = getCachedUserUseCase,
        _logoutUseCase = logoutUseCase,
        _clearUserSessionUseCase = clearUserSessionUseCase,
        super(const SessionInitial()) {
    on<SessionLoginRequested>(_onSessionLoginRequested);
    on<SessionCheckRequested>(_onSessionCheckRequested);
    on<SessionLogoutRequested>(_onSessionLogoutRequested);
    on<SessionUserUpdated>(_onSessionUserUpdated);
  }

  Future<void> _onSessionLoginRequested(
    SessionLoginRequested event,
    Emitter<SessionState> emit,
  ) async {
    emit(const SessionLoading());

    final result = await _loginUseCase(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(SessionError(failure.message)),
      (user) => emit(SessionAuthenticated(user)),
    );
  }

  Future<void> _onSessionCheckRequested(
    SessionCheckRequested event,
    Emitter<SessionState> emit,
  ) async {
    emit(const SessionLoading());

    // Step 1: Check if token exists in secure storage
    final tokenResult = await _getSavedTokenUseCase();

    final token = tokenResult.fold(
      (failure) => null,
      (token) => token,
    );

    if (token == null) {
      // No token → navigate to Login
      emit(const SessionUnauthenticated());
      return;
    }

    // Step 2: Validate token via API (get profile)
    final profileResult = await _getProfileUseCase();

    final failure = profileResult.getLeft().toNullable();
    final user = profileResult.getRight().toNullable();

    if (user != null) {
      // Token is valid → navigate to Home
      emit(SessionAuthenticated(user));
    } else if (failure is NetworkFailure ||
        failure is NotFoundFailure ||
        failure is ServerFailure) {
      // No internet, server unreachable, or API error →
      // try cached user before deciding to logout.
      // This covers edge cases where hasConnection() returns true
      // but the server is still unreachable (e.g., slow/unstable network).
      final cachedResult = await _getCachedUserUseCase();
      cachedResult.fold(
        (_) {
          // No cached user → navigate to Login
          emit(const SessionUnauthenticated());
        },
        (cachedUser) {
          if (cachedUser != null) {
            emit(SessionAuthenticated(cachedUser));
          } else {
            emit(const SessionUnauthenticated());
          }
        },
      );
    } else {
      // Token is invalid (auth failure e.g. 401) → clear session and go to Login
      _logoutUseCase();
      emit(const SessionUnauthenticated());
    }
  }

  Future<void> _onSessionLogoutRequested(
    SessionLogoutRequested event,
    Emitter<SessionState> emit,
  ) async {
    emit(const SessionLoading());
    await _clearUserSessionUseCase();
    emit(const SessionUnauthenticated());
  }

  void _onSessionUserUpdated(
    SessionUserUpdated event,
    Emitter<SessionState> emit,
  ) {
    emit(SessionAuthenticated(event.user));
  }
}
