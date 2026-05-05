import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

import '../../domain/entities/sub_category_detail_entity.dart';

enum SubCategoryStatus { initial, loading, success, failure }

class SubCategoryState extends Equatable {
  final SubCategoryStatus status;
  final SubCategoryDetailEntity? subCategory;
  final PaginatedResponse<ProductEntity> products;
  final String errorMessage;
  final bool isLoadingMore;

  const SubCategoryState({
    this.status = SubCategoryStatus.initial,
    this.subCategory,
    this.products = const PaginatedResponse(data: []),
    this.errorMessage = '',
    this.isLoadingMore = false,
  });

  bool get hasMoreProducts => products.hasMore;
  int get currentPage => products.currentPage;

  SubCategoryState copyWith({
    SubCategoryStatus? status,
    SubCategoryDetailEntity? subCategory,
    PaginatedResponse<ProductEntity>? products,
    String? errorMessage,
    bool? isLoadingMore,
  }) {
    return SubCategoryState(
      status: status ?? this.status,
      subCategory: subCategory ?? this.subCategory,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props =>
      [status, subCategory, products, errorMessage, isLoadingMore];
}
