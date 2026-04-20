import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/auth/domain/usecases/login_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<PasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginWithGoogle>(_onLoginWithGoogle);
    on<LoginWithFacebook>(_onLoginWithFacebook);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email, clearError: true));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password, clearError: true));
  }

  void _onPasswordVisibilityChanged(
    PasswordVisibilityChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: event.isVisible));
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _loginUseCase(
      LoginParams(
        email: state.email,
        password: state.password,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        isLoading: false,
        user: user,
      )),
    );
  }

  Future<void> _onLoginWithGoogle(
    LoginWithGoogle event,
    Emitter<LoginState> emit,
  ) async {
    // TODO: Implement Google login
    emit(state.copyWith(isLoading: true, clearError: true));
    // Placeholder - actual implementation needed
    await Future<void>.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _onLoginWithFacebook(
    LoginWithFacebook event,
    Emitter<LoginState> emit,
  ) async {
    // TODO: Implement Facebook login
    emit(state.copyWith(isLoading: true, clearError: true));
    // Placeholder - actual implementation needed
    await Future<void>.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isLoading: false));
  }
}
