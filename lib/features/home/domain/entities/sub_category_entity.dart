import '../../../../core/imports/imports.dart';

class SubCategoryEntity extends Equatable {
  final int id;
  final String name;
  final String image;

  const SubCategoryEntity({
    required this.id,
    required this.name,
    required this.image,
  });

  @override
  List<Object?> get props => [id, name, image];
}
