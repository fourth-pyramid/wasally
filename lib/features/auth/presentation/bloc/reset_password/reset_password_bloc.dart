import 'package:wassaly/features/auth/domain/usecases/reset_password_usecase.dart';

import '../../../../../core/imports/imports.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordBloc({
    required String email,
    required String token,
    required ResetPasswordUseCase resetPasswordUseCase,
  })  : _resetPasswordUseCase = resetPasswordUseCase,
        super(ResetPasswordState(email: email, token: token)) {
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
      password: event.password,
      clearError: true,
      status: ResetPasswordStatus.initial,
    ));
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(state.copyWith(
      passwordConfirmation: event.password,
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
        token: state.token,
        password: state.password,
        passwordConfirmation: state.passwordConfirmation,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ResetPasswordStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: ResetPasswordStatus.success,
        password: '',
        passwordConfirmation: '',
      )),
    );
  }
}
