part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final String name;
  final String phone;
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool isTermsAccepted;
  final bool isLoading;
  final String? errorMessage;
  final UserEntity? user;

  const SignupState({
    this.name = '',
    this.phone = '',
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isTermsAccepted = false,
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });

  SignupState copyWith({
    String? name,
    String? phone,
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? isTermsAccepted,
    bool? isLoading,
    String? errorMessage,
    UserEntity? user,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return SignupState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      user: clearUser ? null : (user ?? this.user),
    );
  }

  @override
  List<Object?> get props => [
        name,
        phone,
        email,
        password,
        isPasswordVisible,
        isTermsAccepted,
        isLoading,
        errorMessage,
        user,
      ];
}
