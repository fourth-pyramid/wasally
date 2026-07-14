import 'package:wassaly/core/imports/packages_imports.dart';

class AddressEntity extends Equatable {
  final String id;
  final String title;
  final String address;
  final String governorateId;
  final String governorateName;
  final String centerId;
  final String centerName;

  const AddressEntity({
    required this.id,
    required this.title,
    required this.address,
    required this.governorateId,
    required this.governorateName,
    required this.centerId,
    required this.centerName,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        address,
        governorateId,
        governorateName,
        centerId,
        centerName,
      ];
}
