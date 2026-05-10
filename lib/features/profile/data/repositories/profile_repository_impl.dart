import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/core/utils/typedefs.dart';
import 'package:wassaly/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:wassaly/features/profile/domain/entities/address_entity.dart';
import 'package:wassaly/features/profile/domain/entities/center_entity.dart';
import 'package:wassaly/features/profile/domain/entities/governorate_entity.dart';
import 'package:wassaly/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  ProfileRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  FutureEither<UserEntity> updateProfile({
    required String fullName,
    required String phone,
    File? avatar,
    String? password,
    String? currentPassword,
    String? passwordConfirmation,
  }) async {
    try {
      final user = await _remoteDataSource.updateProfile(
        fullName: fullName,
        phone: phone,
        avatar: avatar,
        password: password,
        currentPassword: currentPassword,
        passwordConfirmation: passwordConfirmation,
      );
      await _localDataSource.cacheUser(user);
      return Right(user);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<void> logoutAllDevices() async {
    try {
      await _remoteDataSource.logoutAllDevices();
      await _localDataSource.clearAuthData();
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<void> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
      await _localDataSource.clearAuthData();
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<List<AddressEntity>> getAddresses() async {
    try {
      final addresses = await _remoteDataSource.getAddresses();
      return Right(addresses);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<AddressEntity> createAddress({
    required String title,
    required String address,
    required String governorateId,
    required String centerId,
  }) async {
    try {
      final result = await _remoteDataSource.createAddress(
        title: title,
        address: address,
        governorateId: governorateId,
        centerId: centerId,
      );
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<List<GovernorateEntity>> getGovernorates() async {
    try {
      final governorates = await _remoteDataSource.getGovernorates();
      return Right(governorates);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<List<CenterEntity>> getCenters({
    required String governorateId,
  }) async {
    try {
      final centers = await _remoteDataSource.getCenters(
        governorateId: governorateId,
      );
      return Right(centers);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<AddressEntity> updateAddress({
    required String addressId,
    required String title,
    required String address,
    required String governorateId,
    required String centerId,
  }) async {
    try {
      final result = await _remoteDataSource.updateAddress(
        addressId: addressId,
        title: title,
        address: address,
        governorateId: governorateId,
        centerId: centerId,
      );
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  FutureEither<void> deleteAddress({required String addressId}) async {
    try {
      await _remoteDataSource.deleteAddress(addressId: addressId);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }
}
