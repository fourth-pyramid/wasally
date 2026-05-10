import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

enum SearchStatus { initial, loading, success, failure, loadingMore }

class SearchState extends Equatable {
  final String query;
  final SearchStatus status;
  final PaginatedResponse<ProductEntity> products;
  final String errorMessage;
  final bool hasSearched;

  const SearchState({
    this.query = '',
    this.status = SearchStatus.initial,
    this.products = const PaginatedResponse(data: []),
    this.errorMessage = '',
    this.hasSearched = false,
  });

  SearchState copyWith({
    String? query,
    SearchStatus? status,
    PaginatedResponse<ProductEntity>? products,
    String? errorMessage,
    bool? hasSearched,
  }) {
    return SearchState(
      query: query ?? this.query,
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      hasSearched: hasSearched ?? this.hasSearched,
    );
  }

  @override
  List<Object?> get props => [
        query,
        status,
        products,
        errorMessage,
        hasSearched,
      ];

  bool get isLoading => status == SearchStatus.loading;
  bool get isLoadingMore => status == SearchStatus.loadingMore;
  bool get isSuccess => status == SearchStatus.success;
  bool get isFailure => status == SearchStatus.failure;
  bool get isEmpty => products.data.isEmpty && hasSearched && !isLoading;
}
