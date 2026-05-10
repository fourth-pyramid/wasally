import 'package:wassaly/features/profile/domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.title,
    required super.address,
    required super.governorateId,
    required super.governorateName,
    required super.centerId,
    required super.centerName,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    final governorate = json['governorate'] as Map<String, dynamic>?;
    final center = json['center'] as Map<String, dynamic>?;

    return AddressModel(
      id: json['id'].toString(),
      title: json['title'] as String? ?? '',
      address: json['address'] as String? ?? '',
      governorateId: governorate?['id']?.toString() ?? '',
      governorateName: governorate?['name'] as String? ?? '',
      centerId: center?['id']?.toString() ?? '',
      centerName: center?['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'address': address,
      'governorate': {
        'id': governorateId,
        'name': governorateName,
      },
      'center': {
        'id': centerId,
        'name': centerName,
        'governorate_id': governorateId,
      },
    };
  }
}
