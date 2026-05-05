import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/data/models/user_model.dart';
import 'package:wassaly/features/profile/data/models/address_model.dart';
import 'package:wassaly/features/profile/data/models/center_model.dart';
import 'package:wassaly/features/profile/data/models/governorate_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> updateProfile({
    required String fullName,
    required String phone,
    File? avatar,
    String? password,
    String? currentPassword,
    String? passwordConfirmation,
  });

  Future<void> logoutAllDevices();

  Future<void> deleteAccount();

  Future<List<AddressModel>> getAddresses();

  Future<AddressModel> createAddress({
    required String title,
    required String address,
    required String governorateId,
    required String centerId,
  });

  Future<List<GovernorateModel>> getGovernorates();

  Future<List<CenterModel>> getCenters({
    required String governorateId,
  });

  Future<AddressModel> updateAddress({
    required String addressId,
    required String title,
    required String address,
    required String governorateId,
    required String centerId,
  });

  Future<void> deleteAddress({required String addressId});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioService _dioService;

  const ProfileRemoteDataSourceImpl(this._dioService);

  @override
  Future<UserModel> updateProfile({
    required String fullName,
    required String phone,
    File? avatar,
    String? password,
    String? currentPassword,
    String? passwordConfirmation,
  }) async {
    final formData = FormData.fromMap({
      'full_name': fullName,
      'phone': phone,
      if (avatar != null)
        'avatar': await MultipartFile.fromFile(
          avatar.path,
          filename: avatar.path.split('/').last,
        ),
      if (password != null && password.isNotEmpty) ...{
        'password': password,
        'current_password': currentPassword,
        'password_confirmation': passwordConfirmation,
      },
    });

    final response = await _dioService.post(
      '/api/update-profile',
      data: formData,
    );

    return response.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final message = responseData['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }

        final data = responseData['data'];
        if (data == null) {
          throw const ServerFailure('Invalid response data');
        }

        return UserModel.fromJson(data as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<void> logoutAllDevices() async {
    final result = await _dioService.post('/api/logout-all-devices');

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>?;
        final status = responseData?['status'] as bool? ?? true;
        final message = responseData?['message'] as String? ?? '';

        if (!status && message.isNotEmpty) {
          throw ServerFailure(message);
        }
      },
    );
  }

  @override
  Future<void> deleteAccount() async {
    final result = await _dioService.delete('/api/delete-account');

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>?;
        final status = responseData?['status'] as bool? ?? true;
        final message = responseData?['message'] as String? ?? '';

        if (!status && message.isNotEmpty) {
          throw ServerFailure(message);
        }
      },
    );
  }

  @override
  Future<List<AddressModel>> getAddresses() async {
    final result = await _dioService.get('/api/addresses');

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final message = responseData['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }

        final data = responseData['data'];
        if (data == null) {
          return <AddressModel>[];
        }

        final List<dynamic> list = data as List<dynamic>;
        return list
            .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<AddressModel> createAddress({
    required String title,
    required String address,
    required String governorateId,
    required String centerId,
  }) async {
    final result = await _dioService.post(
      '/api/addresses/create',
      data: {
        'title': title,
        'address': address,
        'governorate_id': governorateId,
        'center_id': centerId,
      },
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final message = responseData['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }

        final data = responseData['data'];
        if (data == null) {
          throw const ServerFailure('Invalid response data');
        }

        return AddressModel.fromJson(data as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<List<GovernorateModel>> getGovernorates() async {
    final result = await _dioService.get('/api/governorates');

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final messageText = responseData['data'] as String? ?? '';

        if (!status) {
          throw ServerFailure(messageText);
        }

        final data = responseData['message'];
        if (data == null || data is! List) {
          return <GovernorateModel>[];
        }

        final List<dynamic> list = data;
        return list
            .map((e) => GovernorateModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<AddressModel> updateAddress({
    required String addressId,
    required String title,
    required String address,
    required String governorateId,
    required String centerId,
  }) async {
    final result = await _dioService.post(
      '/api/addresses/update',
      data: {
        'address_id': addressId,
        'title': title,
        'address': address,
        'governorate_id': governorateId,
        'center_id': centerId,
      },
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final message = responseData['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }

        final data = responseData['data'];
        if (data == null) {
          throw const ServerFailure('Invalid response data');
        }

        return AddressModel.fromJson(data as Map<String, dynamic>);
      },
    );
  }

  @override
  Future<void> deleteAddress({required String addressId}) async {
    final result = await _dioService.delete(
      '/api/addresses/delete',
      queryParameters: {'address_id': addressId},
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>?;
        final status = responseData?['status'] as bool? ?? true;
        final message = responseData?['message'] as String? ?? '';

        if (!status && message.isNotEmpty) {
          throw ServerFailure(message);
        }
      },
    );
  }

  @override
  Future<List<CenterModel>> getCenters({
    required String governorateId,
  }) async {
    final result = await _dioService.get(
      '/api/centers',
      queryParameters: {'governorate_id': governorateId},
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final message = responseData['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }

        final data = responseData['data'];
        if (data == null) {
          return <CenterModel>[];
        }

        final List<dynamic> list = data as List<dynamic>;
        return list
            .map((e) => CenterModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }
}
