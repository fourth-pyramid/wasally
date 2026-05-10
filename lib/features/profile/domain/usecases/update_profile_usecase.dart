import 'dart:io';

import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileParams {
  final String fullName;
  final String phone;
  final File? avatar;
  final String? password;
  final String? currentPassword;
  final String? passwordConfirmation;

  const UpdateProfileParams({
    required this.fullName,
    required this.phone,
    this.avatar,
    this.password,
    this.currentPassword,
    this.passwordConfirmation,
  });
}

class UpdateProfileUseCase {
  final ProfileRepository _repository;

  const UpdateProfileUseCase(this._repository);

  FutureEither<UserEntity> call(UpdateProfileParams params) {
    return _repository.updateProfile(
      fullName: params.fullName,
      phone: params.phone,
      avatar: params.avatar,
      password: params.password,
      currentPassword: params.currentPassword,
      passwordConfirmation: params.passwordConfirmation,
    );
  }
}
