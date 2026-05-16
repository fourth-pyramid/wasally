import 'package:wassaly/core/imports/imports.dart';
import '../models/provider_detail_model.dart';

abstract class ProviderDetailsRemoteDataSource {
  Future<ProviderDetailModel> getProviderDetails(int providerId);
}

class ProviderDetailsRemoteDataSourceImpl
    implements ProviderDetailsRemoteDataSource {
  final DioService _dioService;

  const ProviderDetailsRemoteDataSourceImpl(this._dioService);

  @override
  Future<ProviderDetailModel> getProviderDetails(int providerId) async {
    final result = await _dioService.get(
      '/api/providers/get/$providerId',
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

        final data = responseData['data'] as Map<String, dynamic>? ?? {};
        return ProviderDetailModel.fromJson(data);
      },
    );
  }
}
