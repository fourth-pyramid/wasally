import 'package:wassaly/core/imports/imports.dart';

import '../models/product_detail_model.dart';

abstract class ProductDetailsRemoteDataSource {
  Future<ProductDetailModel> getProductDetails(int productId);
  Future<void> createProductReview({
    required int productId,
    required int rating,
    required String comment,
  });
  Future<void> updateProductReview({
    required int reviewId,
    required int rating,
    required String comment,
  });
}

class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  final DioService _dioService;

  const ProductDetailsRemoteDataSourceImpl(this._dioService);

  @override
  Future<ProductDetailModel> getProductDetails(int productId) async {
    final result = await _dioService.get(
      '/api/product',
      queryParameters: {'product_id': productId},
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
        return ProductDetailModel.fromJson(data);
      },
    );
  }

  @override
  Future<void> createProductReview({
    required int productId,
    required int rating,
    required String comment,
  }) async {
    final result = await _dioService.post(
      '/api/reviews/product/create',
      data: {
        'product_id': productId,
        'rating': rating,
        'comment': comment,
      },
    );

    return result.fold(
      (failure) => throw failure,
      (response) => _throwIfUnsuccessful(response.data),
    );
  }

  @override
  Future<void> updateProductReview({
    required int reviewId,
    required int rating,
    required String comment,
  }) async {
    final result = await _dioService.put(
      '/api/reviews/update/product/$reviewId',
      queryParameters: {
        'comment': comment,
        'rating': rating,
      },
    );

    return result.fold(
      (failure) => throw failure,
      (response) => _throwIfUnsuccessful(response.data),
    );
  }

  void _throwIfUnsuccessful(dynamic data) {
    final responseData = data as Map<String, dynamic>?;
    final status = responseData?['status'] as bool? ?? true;
    final message = responseData?['message'] as String? ?? '';

    if (!status) {
      throw ServerFailure(message);
    }
  }
}
