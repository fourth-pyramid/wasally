import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/sub_category_entity.dart';

import '../../domain/entities/category_detail_entity.dart';

enum CategoryStatus { initial, loading, success, failure }

class CategoryState extends Equatable {
  final CategoryStatus status;
  final CategoryDetailEntity? categoryDetail;
  final PaginatedResponse<SubCategoryEntity> subCategories;
  final String errorMessage;
  final bool isLoadingMore;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categoryDetail,
    this.subCategories = const PaginatedResponse(data: []),
    this.errorMessage = '',
    this.isLoadingMore = false,
  });

  bool get hasMoreSubCategories => subCategories.hasMore;
  int get currentPage => subCategories.currentPage;

  CategoryState copyWith({
    CategoryStatus? status,
    CategoryDetailEntity? categoryDetail,
    PaginatedResponse<SubCategoryEntity>? subCategories,
    String? errorMessage,
    bool? isLoadingMore,
  }) {
    return CategoryState(
      status: status ?? this.status,
      categoryDetail: categoryDetail ?? this.categoryDetail,
      subCategories: subCategories ?? this.subCategories,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categoryDetail,
        subCategories,
        errorMessage,
        isLoadingMore,
      ];
}
