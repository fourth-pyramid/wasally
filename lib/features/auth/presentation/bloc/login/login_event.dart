part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class EmailChanged extends LoginEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends LoginEvent {
  final String password;

  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class PasswordVisibilityChanged extends LoginEvent {
  final bool isVisible;

  const PasswordVisibilityChanged(this.isVisible);

  @override
  List<Object?> get props => [isVisible];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

class LoginWithGoogle extends LoginEvent {
  const LoginWithGoogle();
}

class LoginWithFacebook extends LoginEvent {
  const LoginWithFacebook();
}
