import 'package:wassaly/features/profile/domain/entities/center_entity.dart';

class CenterModel extends CenterEntity {
  const CenterModel({
    required super.id,
    required super.name,
    required super.governorateId,
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      governorateId: json['governorate_id'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'governorate_id': governorateId,
    };
  }
}
