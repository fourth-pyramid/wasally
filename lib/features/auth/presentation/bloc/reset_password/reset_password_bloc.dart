import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/injection/injection.dart';
import 'package:wassaly/features/auth/domain/usecases/reset_password_usecase.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordBloc({
    required String email,
    required String otp,
    ResetPasswordUseCase? resetPasswordUseCase,
  })  : _resetPasswordUseCase =
            resetPasswordUseCase ?? sl<ResetPasswordUseCase>(),
        super(ResetPasswordState(email: email, otp: otp)) {
    on<NewPasswordChanged>(_onNewPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<PasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  void _onNewPasswordChanged(
    NewPasswordChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(state.copyWith(
      newPassword: event.password,
      clearError: true,
      status: ResetPasswordStatus.initial,
    ));
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(state.copyWith(
      confirmPassword: event.password,
      clearError: true,
      status: ResetPasswordStatus.initial,
    ));
  }

  void _onPasswordVisibilityToggled(
    PasswordVisibilityToggled event,
    Emitter<ResetPasswordState> emit,
  ) {
    if (event.isNewPassword) {
      emit(state.copyWith(
        isNewPasswordVisible: !state.isNewPasswordVisible,
      ));
    } else {
      emit(state.copyWith(
        isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
      ));
    }
  }

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    if (!state.canSubmit) {
      if (!state.isNewPasswordValid) {
        emit(state.copyWith(
          status: ResetPasswordStatus.error,
          errorMessage: 'auth.password_too_short',
        ));
      } else if (!state.isConfirmPasswordValid) {
        emit(state.copyWith(
          status: ResetPasswordStatus.error,
          errorMessage: 'auth.passwords_do_not_match',
        ));
      }
      return;
    }

    emit(state.copyWith(
      status: ResetPasswordStatus.loading,
      clearError: true,
    ));

    final result = await _resetPasswordUseCase(
      ResetPasswordParams(
        email: state.email,
        newPassword: state.newPassword,
        otp: state.otp,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ResetPasswordStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: ResetPasswordStatus.success,
        newPassword: '',
        confirmPassword: '',
      )),
    );
  }
}
