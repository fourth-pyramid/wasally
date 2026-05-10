import 'package:wassaly/core/imports/imports.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/sub_category_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<BannerModel>> getBanners();
  Future<List<CategoryModel>> getCategories();
  Future<List<SubCategoryModel>> getPopularServices();
  Future<PaginatedResponse<ProductModel>> getProducts({int page = 1});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioService _dioService;

  const HomeRemoteDataSourceImpl(this._dioService);

  @override
  Future<List<BannerModel>> getBanners() async {
    final result = await _dioService.get('/api/banners');

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
          return <BannerModel>[];
        }

        final List<dynamic> list = data as List<dynamic>;
        return list
            .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final result = await _dioService.get('/api/categories');

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
          return <CategoryModel>[];
        }

        final List<dynamic> list = data as List<dynamic>;
        return list
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<List<SubCategoryModel>> getPopularServices() async {
    final result = await _dioService.get('/api/sub-categories');

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
          return <SubCategoryModel>[];
        }

        final List<dynamic> list = data as List<dynamic>;
        return list
            .map((e) => SubCategoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<PaginatedResponse<ProductModel>> getProducts({
    int page = 1,
  }) async {
    final result = await _dioService.get(
      '/api/products',
      queryParameters: {'page': page},
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
