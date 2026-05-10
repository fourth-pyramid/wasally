import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/auth/domain/usecases/login_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/resend_otp_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;
  final ResendOtpUseCase _resendOtpUseCase;

  LoginBloc({
    required LoginUseCase loginUseCase,
    required ResendOtpUseCase resendOtpUseCase,
  })  : _loginUseCase = loginUseCase,
        _resendOtpUseCase = resendOtpUseCase,
        super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<PasswordVisibilityChanged>(_onPasswordVisibilityChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginRequiresVerification>(_onLoginRequiresVerification);
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
      (failure) async {
        // Check if the error indicates account is not verified
        if (failure.message.contains('auth.account_not_active'.tr())) {
          emit(state.copyWith(
            isLoading: false,
            verificationEmail: state.email,
            clearError: true,
          ));
          // Dispatch event to send OTP
          add(LoginRequiresVerification(state.email));
        } else {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ));
        }
      },
      (user) => emit(state.copyWith(
        isLoading: false,
        user: user,
        clearVerification: true,
      )),
    );
  }

  Future<void> _onLoginRequiresVerification(
    LoginRequiresVerification event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _resendOtpUseCase(
      ResendOtpParams(email: event.email),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        isLoading: false,
        requiresVerification: true,
        verificationEmail: event.email,
      )),
    );
  }
}
