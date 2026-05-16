import 'package:equatable/equatable.dart';

abstract class BrandsEvent extends Equatable {
  const BrandsEvent();

  @override
  List<Object> get props => [];
}

class GetBrandsEvent extends BrandsEvent {}

class GetBrandProductsEvent extends BrandsEvent {
  final int brandId;
  final bool isRefresh;

  const GetBrandProductsEvent({
    required this.brandId,
    this.isRefresh = false,
  });

  @override
  List<Object> get props => [brandId, isRefresh];
}

class LoadMoreBrandProductsEvent extends BrandsEvent {
  final int brandId;

  const LoadMoreBrandProductsEvent({required this.brandId});

  @override
  List<Object> get props => [brandId];
}
