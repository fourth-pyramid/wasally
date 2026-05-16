import 'package:wassaly/core/imports/core_imports.dart';

import '../../../home/data/models/product_model.dart';
import '../models/brand_model.dart';

abstract class BrandsRemoteDataSource {
  Future<List<BrandModel>> getBrands();
  Future<PaginatedResponse<ProductModel>> getBrandProducts({
    required int brandId,
    int page = 1,
  });
}

class BrandsRemoteDataSourceImpl implements BrandsRemoteDataSource {
  final DioService _dioService;

  const BrandsRemoteDataSourceImpl(this._dioService);

  @override
  Future<List<BrandModel>> getBrands() async {
    final result = await _dioService.get('/api/brands');

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
          return <BrandModel>[];
        }

        final List<dynamic> list = data as List<dynamic>;
        return list
            .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<PaginatedResponse<ProductModel>> getBrandProducts({
    required int brandId,
    int page = 1,
  }) async {
    final result = await _dioService.get(
      '/api/brand',
      queryParameters: {
        'brand_id': brandId,
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
        final pagination =
            responseData['pagination'] as Map<String, dynamic>? ?? {};
        final lastPage = pagination['last_page'] as int? ?? 1;
        final total = pagination['total'] as int? ?? 0;
        final currentPage = pagination['current_page'] as int? ?? page;

        if (data == null) {
          return PaginatedResponse(
            data: const <ProductModel>[],
            currentPage: currentPage,
            lastPage: lastPage,
            total: total,
          );
        }

        final List<dynamic> list = data as List<dynamic>;
        final products = list
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return PaginatedResponse(
          data: products,
          currentPage: currentPage,
          lastPage: lastPage,
          total: total,
        );
      },
    );
  }
}
