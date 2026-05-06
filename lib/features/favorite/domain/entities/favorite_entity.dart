import 'package:equatable/equatable.dart';

class FavoriteEntity extends Equatable {
  final int id;
  final String name;
  final String image;
  final String price;
  final String description;
  final bool isFavorite;

  const FavoriteEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [id, name, image, price, description, isFavorite];
}
