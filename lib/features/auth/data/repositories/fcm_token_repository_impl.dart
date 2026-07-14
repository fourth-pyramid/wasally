import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/data/datasources/fcm_token_remote_datasource.dart';
import 'package:wassaly/features/auth/data/models/fcm_token_request_model.dart';
import 'package:wassaly/features/auth/domain/repositories/fcm_token_repository.dart';

class FcmTokenRepositoryImpl implements FcmTokenRepository {
  final FcmTokenRemoteDataSource _remoteDataSource;

  const FcmTokenRepositoryImpl(this._remoteDataSource);

  @override
  FutureEither<void> registerFcmToken({
    required String token,
    required String deviceId,
    required int userId,
  }) async {
    try {
      await _remoteDataSource.registerFcmToken(
        FcmTokenRequestModel(
          token: token,
          deviceId: deviceId,
          userId: userId,
        ),
      );
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } on Object catch (e) {
      return Left(UnknownFailure('FCM token registration failed: $e'));
    }
  }
}
