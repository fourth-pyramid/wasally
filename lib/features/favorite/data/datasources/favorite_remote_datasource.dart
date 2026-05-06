import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/data/models/favorite_model.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

abstract class FavoriteRemoteDataSource {
  Future<PaginatedResponse<ProductEntity>> getFavorites();
  Future<void> addToFavorites(int productId);
  Future<void> removeFromFavorites(int productId);
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final DioService _dioService;

  const FavoriteRemoteDataSourceImpl(this._dioService);

  @override
  Future<PaginatedResponse<ProductEntity>> getFavorites() async {
    final response = await _dioService.get('/api/favorites');

    return response.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>;
        final status = responseData['status'] as bool? ?? false;
        final message = responseData['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }

        final data = responseData['data'] as List<dynamic>? ?? [];
        final pagination = responseData['pagination'] as Map<String, dynamic>?;

        final favorites = data
            .map((item) =>
                FavoriteModel.fromJson(item as Map<String, dynamic>).toEntity())
            .toList();

        return PaginatedResponse<ProductEntity>(
          data: favorites,
          currentPage: pagination?['current_page'] as int? ?? 1,
          lastPage: pagination?['last_page'] as int? ?? 1,
          total: pagination?['total'] as int? ?? favorites.length,
        );
      },
    );
  }

  @override
  Future<void> addToFavorites(int productId) async {
    final response = await _dioService.post(
      '/api/favorites/add',
      data: {'product_id': productId},
    );

    return response.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>?;
        final status = responseData?['status'] as bool? ?? false;
        final message = responseData?['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }
      },
    );
  }

  @override
  Future<void> removeFromFavorites(int productId) async {
    final response = await _dioService.post(
      '/api/favorites/remove',
      data: {'product_id': productId},
    );

    return response.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>?;
        final status = responseData?['status'] as bool? ?? false;
        final message = responseData?['message'] as String? ?? '';

        if (!status) {
          throw ServerFailure(message);
        }
      },
    );
  }
}
