import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/data/models/product_model.dart';

abstract class SearchRemoteDataSource {
  Future<PaginatedResponse<ProductModel>> searchProducts({
    required String query,
    int page = 1,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final DioService _dioService;

  const SearchRemoteDataSourceImpl(this._dioService);

  @override
  Future<PaginatedResponse<ProductModel>> searchProducts({
    required String query,
    int page = 1,
  }) async {
    final result = await _dioService.get(
      '/api/products-search',
      queryParameters: {
        'search': query,
        'page': page,
      },
    );

    return result.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final message = responseData['message'] as String? ?? '';
        final data = responseData['data'];
        final pagination =
            responseData['pagination'] as Map<String, dynamic>? ?? {};
        final lastPage = pagination['last_page'] as int? ?? 1;
        final total = pagination['total'] as int? ?? 0;
        final currentPage = pagination['current_page'] as int? ?? page;

        if (data == null || (data is! List) || (data).isEmpty) {
          return PaginatedResponse(
            data: const <ProductModel>[],
            currentPage: currentPage,
            lastPage: lastPage,
            total: total,
          );
        }

        if (!status) {
          throw ServerFailure(message);
        }

        final List<dynamic> list = data;
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
