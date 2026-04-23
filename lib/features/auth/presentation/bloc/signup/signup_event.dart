part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class NameChanged extends SignupEvent {
  final String name;

  const NameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class PhoneChanged extends SignupEvent {
  final String phone;

  const PhoneChanged(this.phone);

  @override
  List<Object?> get props => [phone];
}

class EmailChanged extends SignupEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends SignupEvent {
  final String password;

  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class PasswordVisibilityChanged extends SignupEvent {
  final bool isVisible;

  const PasswordVisibilityChanged(this.isVisible);

  @override
  List<Object?> get props => [isVisible];
}

class ConfirmPasswordChanged extends SignupEvent {
  final String confirmPassword;

  const ConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class ConfirmPasswordVisibilityChanged extends SignupEvent {
  final bool isVisible;

  const ConfirmPasswordVisibilityChanged(this.isVisible);

  @override
  List<Object?> get props => [isVisible];
}

class TermsAcceptedChanged extends SignupEvent {
  final bool isAccepted;

  const TermsAcceptedChanged(this.isAccepted);

  @override
  List<Object?> get props => [isAccepted];
}

class SignupSubmitted extends SignupEvent {
  const SignupSubmitted();
}

class SignupWithGoogle extends SignupEvent {
  const SignupWithGoogle();
}

class SignupWithFacebook extends SignupEvent {
  const SignupWithFacebook();
}
