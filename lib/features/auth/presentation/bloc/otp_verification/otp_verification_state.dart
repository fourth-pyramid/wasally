part of 'otp_verification_bloc.dart';

enum OtpVerificationStatus {
  initial,
  loading,
  verifiedForRegister,
  verifiedForForgotPassword,
  verifiedForLogin,
  error,
}

enum ResendOtpStatus {
  initial,
  loading,
  success,
  error,
}

class OtpVerificationState extends Equatable {
  final String otp;
  final String email;
  final VerificationType verificationType;
  final OtpVerificationStatus verificationStatus;
  final ResendOtpStatus resendStatus;
  final String? errorMessage;
  final int timerSeconds;
  final bool isTimerRunning;
  final VerifyOtpResponseEntity? verifyOtpResponse;
  final String? resetToken;

  const OtpVerificationState({
    required this.email, this.otp = '',
    this.verificationType = VerificationType.register,
    this.verificationStatus = OtpVerificationStatus.initial,
    this.resendStatus = ResendOtpStatus.initial,
    this.errorMessage,
    this.timerSeconds = 0,
    this.isTimerRunning = false,
    this.verifyOtpResponse,
    this.resetToken,
  });

  bool get isOtpComplete => otp.length == 6;
  bool get canVerify =>
      isOtpComplete && verificationStatus != OtpVerificationStatus.loading;
  bool get canResend =>
      !isTimerRunning && resendStatus != ResendOtpStatus.loading;

  String get formattedTimer {
    final minutes = (timerSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (timerSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  OtpVerificationState copyWith({
    String? otp,
    String? email,
    VerificationType? verificationType,
    OtpVerificationStatus? verificationStatus,
    ResendOtpStatus? resendStatus,
    String? errorMessage,
    bool clearError = false,
    int? timerSeconds,
    bool? isTimerRunning,
    VerifyOtpResponseEntity? verifyOtpResponse,
    String? resetToken,
  }) => OtpVerificationState(
      otp: otp ?? this.otp,
      email: email ?? this.email,
      verificationType: verificationType ?? this.verificationType,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      resendStatus: resendStatus ?? this.resendStatus,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      verifyOtpResponse: verifyOtpResponse ?? this.verifyOtpResponse,
      resetToken: resetToken ?? this.resetToken,
    );

  @override
  List<Object?> get props => [
        otp,
        email,
        verificationType,
        verificationStatus,
        resendStatus,
        errorMessage,
        timerSeconds,
        isTimerRunning,
        verifyOtpResponse,
        resetToken,
      ];
}
