part of 'otp_verification_bloc.dart';

abstract class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();

  @override
  List<Object?> get props => [];
}

class OtpDigitChanged extends OtpVerificationEvent {
  final String otp;

  const OtpDigitChanged(this.otp);

  @override
  List<Object?> get props => [otp];
}

class VerifyOtpSubmitted extends OtpVerificationEvent {
  const VerifyOtpSubmitted();
}

class ResendOtpRequested extends OtpVerificationEvent {
  const ResendOtpRequested();
}

class TimerTicked extends OtpVerificationEvent {
  final int remainingSeconds;

  const TimerTicked(this.remainingSeconds);

  @override
  List<Object?> get props => [remainingSeconds];
}

class TimerCompleted extends OtpVerificationEvent {
  const TimerCompleted();
}

class TimerStarted extends OtpVerificationEvent {
  const TimerStarted();
}
