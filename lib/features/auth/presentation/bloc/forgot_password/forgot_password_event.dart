part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class EmailChanged extends ForgotPasswordEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class SendOtpSubmitted extends ForgotPasswordEvent {
  const SendOtpSubmitted();
}
