part of 'reset_password_bloc.dart';

enum ResetPasswordStatus { initial, loading, success, error }

class ResetPasswordState extends Equatable {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;
  final ResetPasswordStatus status;
  final String? errorMessage;

  const ResetPasswordState({
    required this.email,
    required this.otp,
    this.newPassword = '',
    this.confirmPassword = '',
    this.isNewPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.status = ResetPasswordStatus.initial,
    this.errorMessage,
  });

  bool get isNewPasswordValid => newPassword.length >= 8;

  bool get isConfirmPasswordValid =>
      confirmPassword.isNotEmpty && confirmPassword == newPassword;

  bool get canSubmit =>
      isNewPasswordValid &&
      isConfirmPasswordValid &&
      status != ResetPasswordStatus.loading;

  /// Calculates password strength from 0 to 4 based on length
  /// 0: Very Weak (empty), 1: Weak (1-4 chars), 2: Fair (5-7 chars)
  /// 3: Good (8-11 chars), 4: Strong (12+ chars)
  int get passwordStrength {
    if (newPassword.isEmpty) return 0;
    if (newPassword.length < 5) return 1;
    if (newPassword.length < 8) return 2;
    if (newPassword.length < 12) return 3;
    return 4;
  }

  String? get newPasswordError {
    if (newPassword.isEmpty) return null;
    if (newPassword.length < 8) return 'auth.password_too_short';
    return null;
  }

  String? get confirmPasswordError {
    if (confirmPassword.isEmpty) return null;
    if (confirmPassword != newPassword) return 'auth.passwords_do_not_match';
    return null;
  }

  ResetPasswordState copyWith({
    String? email,
    String? otp,
    String? newPassword,
    String? confirmPassword,
    bool? isNewPasswordVisible,
    bool? isConfirmPasswordVisible,
    ResetPasswordStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ResetPasswordState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isNewPasswordVisible: isNewPasswordVisible ?? this.isNewPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        email,
        otp,
        newPassword,
        confirmPassword,
        isNewPasswordVisible,
        isConfirmPasswordVisible,
        status,
        errorMessage,
      ];
}
