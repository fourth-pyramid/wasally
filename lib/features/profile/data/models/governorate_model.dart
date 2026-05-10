import 'package:wassaly/features/profile/domain/entities/governorate_entity.dart';

class GovernorateModel extends GovernorateEntity {
  const GovernorateModel({
    required super.id,
    required super.name,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
