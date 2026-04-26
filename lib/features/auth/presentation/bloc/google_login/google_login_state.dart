part of 'google_login_bloc.dart';

class GoogleLoginState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final UserEntity? user;

  const GoogleLoginState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });

  GoogleLoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    UserEntity? user,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return GoogleLoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      user: clearUser ? null : (user ?? this.user),
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, user];
}
