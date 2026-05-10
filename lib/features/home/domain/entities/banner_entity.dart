import '../../../../core/imports/imports.dart';

class BannerEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String image;
  final String type;

  const BannerEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, description, image, type];
}
