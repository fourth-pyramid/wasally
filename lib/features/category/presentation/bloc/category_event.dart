import '../../../../core/imports/imports.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchCategoryDetailEvent extends CategoryEvent {
  final int categoryId;

  const FetchCategoryDetailEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class LoadMoreSubCategoriesEvent extends CategoryEvent {
  final int categoryId;

  const LoadMoreSubCategoriesEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
