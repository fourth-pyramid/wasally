import 'package:wassaly/core/imports/packages_imports.dart';

class CouponEntity extends Equatable {
  final int id;
  final String code;
  final String title;
  final String description;
  final dynamic value;
  final String type; // 'percentage' or 'fixed'
  final int? userUsageLimit;
  final bool isValid;

  const CouponEntity({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.value,
    required this.type,
    required this.isValid, this.userUsageLimit,
  });

  @override
  List<Object?> get props => [
        id,
        code,
        title,
        description,
        value,
        type,
        userUsageLimit,
        isValid,
      ];
}
