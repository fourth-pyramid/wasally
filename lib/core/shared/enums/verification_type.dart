enum VerificationType {
  register,
  forgotPassword;

  bool get isRegister => this == VerificationType.register;
  bool get isForgotPassword => this == VerificationType.forgotPassword;
}
