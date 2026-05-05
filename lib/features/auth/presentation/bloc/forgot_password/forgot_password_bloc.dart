import 'package:wassaly/core/injection/injection.dart';
import 'package:wassaly/features/auth/domain/usecases/forget_send_otp_usecase.dart';

import '../../../../../core/imports/imports.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgetSendOtpUseCase _forgetSendOtpUseCase;

  ForgotPasswordBloc({
    ForgetSendOtpUseCase? forgetSendOtpUseCase,
  })  : _forgetSendOtpUseCase =
            forgetSendOtpUseCase ?? sl<ForgetSendOtpUseCase>(),
        super(const ForgotPasswordState()) {
    on<EmailChanged>(_onEmailChanged);
    on<SendOtpSubmitted>(_onSendOtpSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<ForgotPasswordState> emit) {
    emit(state.copyWith(email: event.email, clearError: true));
  }

  Future<void> _onSendOtpSubmitted(
    SendOtpSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _forgetSendOtpUseCase(
      ForgetSendOtpParams(email: state.email),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
      )),
    );
  }
}
