import '../../../../core/imports/imports.dart';

abstract class SubCategoryEvent extends Equatable {
  const SubCategoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchSubCategoryDetailEvent extends SubCategoryEvent {
  final int subCategoryId;

  const FetchSubCategoryDetailEvent(this.subCategoryId);

  @override
  List<Object?> get props => [subCategoryId];
}

class LoadMoreProductsEvent extends SubCategoryEvent {
  final int subCategoryId;

  const LoadMoreProductsEvent(this.subCategoryId);

  @override
  List<Object?> get props => [subCategoryId];
}
