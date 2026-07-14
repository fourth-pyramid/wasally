import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/profile/domain/usecases/update_profile_usecase.dart';

class UpdateUserProfileUseCase {
  final UpdateProfileUseCase _updateProfileUseCase;

  UpdateUserProfileUseCase(this._updateProfileUseCase);

  Future<Either<Failure, dynamic>> call({
    required String fullName,
    required String phone,
  }) async =>
      _updateProfileUseCase(
        UpdateProfileParams(
          fullName: fullName,
          phone: phone,
        ),
      );
}
