import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

import 'service_entity.dart';

class SubCategoryDetailEntity extends Equatable {
  final int id;
  final String name;
  final String image;
  final List<ServiceEntity> services;
  final PaginatedResponse<ProductEntity> products;

  const SubCategoryDetailEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.services,
    required this.products,
  });

  @override
  List<Object?> get props => [id, name, image, services, products];
}
