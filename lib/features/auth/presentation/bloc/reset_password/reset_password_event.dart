part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class NewPasswordChanged extends ResetPasswordEvent {
  final String password;

  const NewPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends ResetPasswordEvent {
  final String password;

  const ConfirmPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class PasswordVisibilityToggled extends ResetPasswordEvent {
  final bool isNewPassword;

  const PasswordVisibilityToggled({required this.isNewPassword});

  @override
  List<Object?> get props => [isNewPassword];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  const ResetPasswordSubmitted();
}
