import 'dart:io';

import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/profile/domain/entities/address_entity.dart';
import 'package:wassaly/features/profile/domain/entities/center_entity.dart';
import 'package:wassaly/features/profile/domain/entities/governorate_entity.dart';

abstract class ProfileRepository {
  FutureEither<UserEntity> updateProfile({
    required String fullName,
    required String phone,
    File? avatar,
    String? password,
    String? currentPassword,
    String? passwordConfirmation,
  });

  FutureEither<void> logoutAllDevices();

  FutureEither<void> deleteAccount();

  FutureEither<List<AddressEntity>> getAddresses();

  FutureEither<AddressEntity> createAddress({
    required String title,
    required String address,
    required String governorateId,
    required String centerId,
  });

  FutureEither<List<GovernorateEntity>> getGovernorates();

  FutureEither<List<CenterEntity>> getCenters({
    required String governorateId,
  });

  FutureEither<AddressEntity> updateAddress({
    required String addressId,
    required String title,
    required String address,
    required String governorateId,
    required String centerId,
  });

  FutureEither<void> deleteAddress({required String addressId});
}
