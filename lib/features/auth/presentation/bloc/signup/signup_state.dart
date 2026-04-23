part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isTermsAccepted;
  final bool isLoading;
  final String? errorMessage;
  final bool isRegistered;

  const SignupState({
    this.name = '',
    this.phone = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isTermsAccepted = false,
    this.isLoading = false,
    this.errorMessage,
    this.isRegistered = false,
  });

  SignupState copyWith({
    String? name,
    String? phone,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isTermsAccepted,
    bool? isLoading,
    String? errorMessage,
    bool? isRegistered,
    bool clearError = false,
    bool clearRegistered = false,
  }) {
    return SignupState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isRegistered:
          clearRegistered ? false : (isRegistered ?? this.isRegistered),
    );
  }

  @override
  List<Object?> get props => [
        name,
        phone,
        email,
        password,
        confirmPassword,
        isPasswordVisible,
        isConfirmPasswordVisible,
        isTermsAccepted,
        isLoading,
        errorMessage,
        isRegistered,
      ];
}
