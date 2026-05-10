import 'package:wassaly/core/imports/imports.dart';

import '../models/sub_category_detail_model.dart';

abstract class SubCategoryRemoteDataSource {
  Future<SubCategoryDetailModel> getSubCategoryDetail(int subCategoryId,
      {int page = 1});
}

class SubCategoryRemoteDataSourceImpl implements SubCategoryRemoteDataSource {
  final DioService _dioService;

  SubCategoryRemoteDataSourceImpl(this._dioService);

  @override
  Future<SubCategoryDetailModel> getSubCategoryDetail(int subCategoryId,
      {int page = 1}) async {
    final result = await _dioService.get(
      '/api/sub-category',
      queryParameters: {
        'sub_category_id': subCategoryId,
        'page': page,
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
          throw const ServerFailure('No data found');
        }

        final pagination = responseData['pagination'] as Map<String, dynamic>?;
        final subCategoryData = data is List
            ? (data.isEmpty ? null : data.first)
            : data;

        if (subCategoryData is! Map<String, dynamic>) {
          throw const ServerFailure('No data found');
        }

        return SubCategoryDetailModel.fromJson(
          subCategoryData,
          pagination: pagination,
        );
      },
    );
  }
}
