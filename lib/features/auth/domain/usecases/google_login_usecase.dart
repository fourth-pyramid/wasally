import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/auth/domain/repositories/auth_repository.dart';

class GoogleLoginUseCase {
  final AuthRepository _repository;

  const GoogleLoginUseCase(this._repository);

  /// Initiates Google login flow by opening external browser
  /// Returns true if browser was opened successfully
  Future<bool> openGoogleLogin() {
    return _repository.openGoogleLoginUrl();
  }

  /// Completes Google login with callback data from deep link
  FutureEither<UserEntity> completeGoogleLogin({
    required String token,
    required String id,
    required String fullName,
    required String email,
    String? avatar,
  }) {
    return _repository.googleLogin(
      token: token,
      id: id,
      fullName: fullName,
      email: email,
      avatar: avatar,
    );
  }
}
