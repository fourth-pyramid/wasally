import 'dart:async';

import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/core/injection/injection.dart';
import 'package:wassaly/features/auth/data/models/verify_otp_response_model.dart';
import 'package:wassaly/features/auth/domain/usecases/forget_verify_otp_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/verify_otp_usecase.dart';

part 'otp_verification_event.dart';
part 'otp_verification_state.dart';

class OtpVerificationBloc
    extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ForgetVerifyOtpUseCase _forgetVerifyOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase;
  Timer? _timer;

  static const int _timerDuration = 60;

  OtpVerificationBloc({
    required String email,
    required VerificationType verificationType,
    VerifyOtpUseCase? verifyOtpUseCase,
    ForgetVerifyOtpUseCase? forgetVerifyOtpUseCase,
    ResendOtpUseCase? resendOtpUseCase,
  })  : _verifyOtpUseCase = verifyOtpUseCase ?? sl<VerifyOtpUseCase>(),
        _forgetVerifyOtpUseCase =
            forgetVerifyOtpUseCase ?? sl<ForgetVerifyOtpUseCase>(),
        _resendOtpUseCase = resendOtpUseCase ?? sl<ResendOtpUseCase>(),
        super(OtpVerificationState(
          email: email,
          verificationType: verificationType,
        )) {
    on<OtpDigitChanged>(_onOtpDigitChanged);
    on<VerifyOtpSubmitted>(_onVerifyOtpSubmitted);
    on<ResendOtpRequested>(_onResendOtpRequested);
    on<TimerTicked>(_onTimerTicked);
    on<TimerCompleted>(_onTimerCompleted);
    on<TimerStarted>(_onTimerStarted);

    // Start timer on initialization
    add(const TimerStarted());
  }

  void _onOtpDigitChanged(
    OtpDigitChanged event,
    Emitter<OtpVerificationState> emit,
  ) {
    emit(state.copyWith(
      otp: event.otp,
      clearError: true,
      verificationStatus: OtpVerificationStatus.initial,
    ));
  }

  Future<void> _onVerifyOtpSubmitted(
    VerifyOtpSubmitted event,
    Emitter<OtpVerificationState> emit,
  ) async {
    if (!state.isOtpComplete) {
      emit(state.copyWith(
        verificationStatus: OtpVerificationStatus.error,
        errorMessage: 'otp.invalid_otp',
      ));
      return;
    }

    emit(state.copyWith(
      verificationStatus: OtpVerificationStatus.loading,
      clearError: true,
    ));

    if (state.verificationType.isForgotPassword) {
      final result = await _forgetVerifyOtpUseCase(
        ForgetVerifyOtpParams(
          email: state.email,
          otp: state.otp,
        ),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          verificationStatus: OtpVerificationStatus.error,
          errorMessage: failure.message,
        )),
        (response) => emit(state.copyWith(
          verificationStatus: OtpVerificationStatus.verifiedForForgotPassword,
          resetToken: response.token,
        )),
      );
    } else if (state.verificationType.isLogin) {
      final result = await _verifyOtpUseCase(
        VerifyOtpParams(
          email: state.email,
          otp: state.otp,
        ),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          verificationStatus: OtpVerificationStatus.error,
          errorMessage: failure.message,
        )),
        (response) => emit(state.copyWith(
          verificationStatus: OtpVerificationStatus.verifiedForLogin,
          verifyOtpResponse: response,
        )),
      );
    } else {
      final result = await _verifyOtpUseCase(
        VerifyOtpParams(
          email: state.email,
          otp: state.otp,
        ),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          verificationStatus: OtpVerificationStatus.error,
          errorMessage: failure.message,
        )),
        (response) => emit(state.copyWith(
          verificationStatus: OtpVerificationStatus.verifiedForRegister,
          verifyOtpResponse: response,
        )),
      );
    }
  }

  Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<OtpVerificationState> emit,
  ) async {
    if (state.isTimerRunning) return;

    emit(state.copyWith(
      resendStatus: ResendOtpStatus.loading,
      clearError: true,
    ));

    final result = await _resendOtpUseCase(
      ResendOtpParams(email: state.email),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        resendStatus: ResendOtpStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        emit(state.copyWith(
          resendStatus: ResendOtpStatus.success,
          timerSeconds: _timerDuration,
          isTimerRunning: true,
        ));
        _startTimer();
      },
    );
  }

  void _onTimerTicked(
    TimerTicked event,
    Emitter<OtpVerificationState> emit,
  ) {
    emit(state.copyWith(timerSeconds: event.remainingSeconds));
  }

  void _onTimerCompleted(
    TimerCompleted event,
    Emitter<OtpVerificationState> emit,
  ) {
    _timer?.cancel();
    emit(state.copyWith(
      isTimerRunning: false,
      timerSeconds: 0,
      resendStatus: ResendOtpStatus.initial,
    ));
  }

  void _onTimerStarted(
    TimerStarted event,
    Emitter<OtpVerificationState> emit,
  ) {
    emit(state.copyWith(
      timerSeconds: _timerDuration,
      isTimerRunning: true,
    ));
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final remaining = _timerDuration - timer.tick;
        if (remaining > 0) {
          add(TimerTicked(remaining));
        } else {
          add(const TimerCompleted());
          timer.cancel();
        }
      },
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
