
import '../../../../core/imports/imports.dart';

class ServiceEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String? image;

  const ServiceEntity({
    required this.id,
    required this.title,
    required this.description,
    this.image,
  });

  @override
  List<Object?> get props => [id, title, description, image];
}
