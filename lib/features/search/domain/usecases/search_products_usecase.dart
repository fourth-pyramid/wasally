import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/search/domain/repositories/search_repository.dart';

class SearchProductsUseCase {
  final SearchRepository _repository;

  const SearchProductsUseCase(this._repository);

  Future<Either<Failure, PaginatedResponse<ProductEntity>>> call({
    required String query,
    int page = 1,
  }) async {
    return await _repository.searchProducts(query: query, page: page);
  }
}
