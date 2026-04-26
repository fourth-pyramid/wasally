import 'dart:async';

import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/auth/domain/usecases/google_login_usecase.dart';

part 'google_login_event.dart';
part 'google_login_state.dart';

class GoogleLoginBloc extends Bloc<GoogleLoginEvent, GoogleLoginState> {
  final GoogleLoginUseCase _googleLoginUseCase;
  StreamSubscription<GoogleLoginCallbackData?>? _deepLinkSubscription;

  GoogleLoginBloc({
    required GoogleLoginUseCase googleLoginUseCase,
  })  : _googleLoginUseCase = googleLoginUseCase,
        super(const GoogleLoginState()) {
    on<GoogleLoginStarted>(_onGoogleLoginStarted);
    on<GoogleLoginCallbackReceived>(_onGoogleLoginCallbackReceived);
    on<GoogleLoginCancelled>(_onGoogleLoginCancelled);
    on<GoogleLoginDeepLinkError>(_onGoogleLoginDeepLinkError);
  }

  @override
  Future<void> close() {
    _deepLinkSubscription?.cancel();
    return super.close();
  }

  Future<void> _onGoogleLoginStarted(
    GoogleLoginStarted event,
    Emitter<GoogleLoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearUser: true));

    // Listen for deep link callbacks
    _deepLinkSubscription?.cancel();
    AppLogger.info('🔍 GoogleLoginBloc: Starting to listen for deep links...');
    _deepLinkSubscription = DeepLinkService.instance.callbackStream.listen(
      (callbackData) {
        AppLogger.info(
            '🔍 GoogleLoginBloc: Received callback data: $callbackData');
        if (callbackData != null) {
          add(GoogleLoginCallbackReceived(callbackData));
        } else {
          add(const GoogleLoginDeepLinkError('Invalid callback data'));
        }
      },
      onError: (error) {
        AppLogger.error('🔍 GoogleLoginBloc: Deep link error: $error');
        add(GoogleLoginDeepLinkError('Deep link error: $error'));
      },
    );

    // Open external browser for Google login
    final opened = await _googleLoginUseCase.openGoogleLogin();

    if (!opened) {
      _deepLinkSubscription?.cancel();
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Could not open browser for Google login',
      ));
    }
    // Don't set isLoading to false here - we wait for the deep link callback
  }

  Future<void> _onGoogleLoginCallbackReceived(
    GoogleLoginCallbackReceived event,
    Emitter<GoogleLoginState> emit,
  ) async {
    final callbackData = event.callbackData;

    if (!callbackData.isSuccess) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Google login was not successful',
      ));
      return;
    }

    // Complete the login with callback data
    final result = await _googleLoginUseCase.completeGoogleLogin(
      token: callbackData.token,
      id: callbackData.id,
      fullName: callbackData.fullName,
      email: callbackData.email,
      avatar: callbackData.avatar,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        isLoading: false,
        user: user,
        clearError: true,
      )),
    );

    // Cancel subscription after handling
    _deepLinkSubscription?.cancel();
    _deepLinkSubscription = null;
  }

  void _onGoogleLoginCancelled(
    GoogleLoginCancelled event,
    Emitter<GoogleLoginState> emit,
  ) {
    _deepLinkSubscription?.cancel();
    _deepLinkSubscription = null;
    emit(state.copyWith(
      isLoading: false,
      errorMessage: 'Login cancelled',
    ));
  }

  void _onGoogleLoginDeepLinkError(
    GoogleLoginDeepLinkError event,
    Emitter<GoogleLoginState> emit,
  ) {
    _deepLinkSubscription?.cancel();
    _deepLinkSubscription = null;
    emit(state.copyWith(
      isLoading: false,
      errorMessage: event.error,
    ));
  }
}
