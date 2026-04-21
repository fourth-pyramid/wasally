import 'package:wassaly/core/imports/packages_imports.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(const ForgotPasswordState()) {
    on<EmailChanged>(_onEmailChanged);
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<ForgotPasswordState> emit) {
    emit(state.copyWith(email: event.email, clearError: true));
  }

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    // TODO: Implement actual password reset API call
    await Future<void>.delayed(const Duration(seconds: 1));

    // Simulate success for now
    emit(state.copyWith(
      isLoading: false,
      isSuccess: true,
    ));
  }
}
