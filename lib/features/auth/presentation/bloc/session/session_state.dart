part of 'session_bloc.dart';

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {
  const SessionInitial();
}

class SessionLoading extends SessionState {
  const SessionLoading();
}

class SessionAuthenticated extends SessionState {
  final UserEntity user;

  const SessionAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated();
}

class SessionError extends SessionState {
  final String message;

  const SessionError(this.message);

  @override
  List<Object?> get props => [message];
}
