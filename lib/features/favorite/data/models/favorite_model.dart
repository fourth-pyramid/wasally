import 'package:wassaly/features/favorite/domain/entities/favorite_entity.dart';

class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    required super.id,
    required super.name,
    required super.image,
    required super.price,
    required super.description,
    required super.isFavorite,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      price: json['price'] as String,
      description: json['description'] as String,
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'description': description,
      'is_favorite': isFavorite,
    };
  }

  FavoriteEntity toEntity() {
    return FavoriteEntity(
      id: id,
      name: name,
      image: image,
      price: price,
      description: description,
      isFavorite: isFavorite,
    );
  }
}
