import 'package:equatable/equatable.dart';

class BrandEntity extends Equatable {
  final int id;
  final String name;
  final String image;

  const BrandEntity({
    required this.id,
    required this.name,
    required this.image,
  });

  @override
  List<Object?> get props => [id, name, image];
}
