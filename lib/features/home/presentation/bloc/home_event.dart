import '../../../../core/imports/imports.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class GetBannersEvent extends HomeEvent {}

class GetCategoriesEvent extends HomeEvent {}

class GetPopularServicesEvent extends HomeEvent {}

class LoadMorePopularServicesEvent extends HomeEvent {}

class GetProductsEvent extends HomeEvent {}

class LoadMoreProductsEvent extends HomeEvent {}

class HomeInitializeEvent extends HomeEvent {}
