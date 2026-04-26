part of 'google_login_bloc.dart';

abstract class GoogleLoginEvent extends Equatable {
  const GoogleLoginEvent();

  @override
  List<Object?> get props => [];
}

/// Start Google login flow - opens external browser
class GoogleLoginStarted extends GoogleLoginEvent {
  const GoogleLoginStarted();
}

/// Google login callback received from deep link
class GoogleLoginCallbackReceived extends GoogleLoginEvent {
  final GoogleLoginCallbackData callbackData;

  const GoogleLoginCallbackReceived(this.callbackData);

  @override
  List<Object?> get props => [callbackData];
}

/// User cancelled the login
class GoogleLoginCancelled extends GoogleLoginEvent {
  const GoogleLoginCancelled();
}

/// Error occurred during deep link handling
class GoogleLoginDeepLinkError extends GoogleLoginEvent {
  final String error;

  const GoogleLoginDeepLinkError(this.error);

  @override
  List<Object?> get props => [error];
}
