import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/get_saved_token_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/login_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/logout_usecase.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final LoginUseCase _loginUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final GetSavedTokenUseCase _getSavedTokenUseCase;
  final LogoutUseCase _logoutUseCase;

  SessionBloc({
    required LoginUseCase loginUseCase,
    required GetProfileUseCase getProfileUseCase,
    required GetSavedTokenUseCase getSavedTokenUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _getProfileUseCase = getProfileUseCase,
        _getSavedTokenUseCase = getSavedTokenUseCase,
        _logoutUseCase = logoutUseCase,
        super(const SessionInitial()) {
    on<SessionLoginRequested>(_onSessionLoginRequested);
    on<SessionCheckRequested>(_onSessionCheckRequested);
    on<SessionLogoutRequested>(_onSessionLogoutRequested);
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

    final tokenResult = await _getSavedTokenUseCase();

    final token = tokenResult.fold(
      (failure) => null,
      (token) => token,
    );

    if (token == null) {
      emit(const SessionUnauthenticated());
      return;
    }

    final profileResult = await _getProfileUseCase();

    profileResult.fold(
      (failure) {
        _logoutUseCase();
        emit(const SessionUnauthenticated());
      },
      (user) => emit(SessionAuthenticated(user)),
    );
  }

  Future<void> _onSessionLogoutRequested(
    SessionLogoutRequested event,
    Emitter<SessionState> emit,
  ) async {
    emit(const SessionLoading());

    await _logoutUseCase();

    emit(const SessionUnauthenticated());
  }
}
