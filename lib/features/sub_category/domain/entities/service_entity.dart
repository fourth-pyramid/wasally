import '../../../../core/imports/imports.dart';

class ServiceEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String? image;
  final num price;
  final bool isFavorite;

  const ServiceEntity({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    required this.price,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [id, title, description, image, price, isFavorite];
}
