import 'package:wassaly/core/imports/packages_imports.dart';

class CenterEntity extends Equatable {
  final String id;
  final String name;
  final String governorateId;

  const CenterEntity({
    required this.id,
    required this.name,
    required this.governorateId,
  });

  @override
  List<Object?> get props => [id, name, governorateId];
}
