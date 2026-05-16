import 'package:wassaly/core/imports/imports.dart';

import '../models/category_detail_model.dart';

abstract class CategoryRemoteDataSource {
  Future<CategoryDetailModel> getCategoryDetail(int categoryId, {int page = 1});
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final DioService _dioService;

  CategoryRemoteDataSourceImpl(this._dioService);

  @override
  Future<CategoryDetailModel> getCategoryDetail(int categoryId,
      {int page = 1}) async {
    final result = await _dioService.get(
      '/api/category',
      queryParameters: {
        'category_id': categoryId,
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

        final category = responseData['category'] as Map<String, dynamic>?;
        if (category == null) {
          throw const ServerFailure('No category found');
        }

        final data = responseData['data'] as List<dynamic>? ?? [];
        final pagination = responseData['pagination'] as Map<String, dynamic>?;

        return CategoryDetailModel.fromJson(
          category: category,
          subCategories: data,
          pagination: pagination,
        );
      },
    );
  }
}
