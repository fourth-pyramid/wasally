import 'package:wassaly/core/imports/packages_imports.dart';

class VerifyOtpResponseEntity extends Equatable {
  final bool status;
  final String message;
  final VerifyOtpUserDataEntity? data;

  const VerifyOtpResponseEntity({
    required this.status,
    required this.message,
    this.data,
  });

  @override
  List<Object?> get props => [status, message, data];
}

class VerifyOtpUserDataEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? type;

  const VerifyOtpUserDataEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.type,
  });

  @override
  List<Object?> get props => [id, name, email, phone, avatar, type];
}
