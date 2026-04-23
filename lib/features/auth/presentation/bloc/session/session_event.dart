part of 'session_bloc.dart';

sealed class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class SessionLoginRequested extends SessionEvent {
  final String email;
  final String password;

  const SessionLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SessionCheckRequested extends SessionEvent {
  const SessionCheckRequested();
}

class SessionLogoutRequested extends SessionEvent {
  const SessionLogoutRequested();
}
