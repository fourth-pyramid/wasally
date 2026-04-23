part of 'reset_password_bloc.dart';

enum ResetPasswordStatus { initial, loading, success, error }

class ResetPasswordState extends Equatable {
  final String email;
  final String token;
  final String password;
  final String passwordConfirmation;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;
  final ResetPasswordStatus status;
  final String? errorMessage;

  const ResetPasswordState({
    required this.email,
    required this.token,
    this.password = '',
    this.passwordConfirmation = '',
    this.isNewPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.status = ResetPasswordStatus.initial,
    this.errorMessage,
  });

  bool get isNewPasswordValid => password.length >= 8;

  bool get isConfirmPasswordValid =>
      passwordConfirmation.isNotEmpty && passwordConfirmation == password;

  bool get canSubmit =>
      isNewPasswordValid &&
      isConfirmPasswordValid &&
      status != ResetPasswordStatus.loading;

  /// Calculates password strength from 0 to 4 based on length
  /// 0: Very Weak (empty), 1: Weak (1-4 chars), 2: Fair (5-7 chars)
  /// 3: Good (8-11 chars), 4: Strong (12+ chars)
  int get passwordStrength {
    if (password.isEmpty) return 0;
    if (password.length < 5) return 1;
    if (password.length < 8) return 2;
    if (password.length < 12) return 3;
    return 4;
  }

  String? get newPasswordError {
    if (password.isEmpty) return null;
    if (password.length < 8) return 'auth.password_too_short';
    return null;
  }

  String? get confirmPasswordError {
    if (passwordConfirmation.isEmpty) return null;
    if (passwordConfirmation != password) return 'auth.passwords_do_not_match';
    return null;
  }

  ResetPasswordState copyWith({
    String? email,
    String? token,
    String? password,
    String? passwordConfirmation,
    bool? isNewPasswordVisible,
    bool? isConfirmPasswordVisible,
    ResetPasswordStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ResetPasswordState(
      email: email ?? this.email,
      token: token ?? this.token,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
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
        token,
        password,
        passwordConfirmation,
        isNewPasswordVisible,
        isConfirmPasswordVisible,
        status,
        errorMessage,
      ];
}
