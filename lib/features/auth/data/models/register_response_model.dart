import '../../../../core/imports/imports.dart';

/// Model for parsing the registration API response
class RegisterResponseModel extends Equatable {
  final bool status;
  final String message;
  final RegisterDataModel? data;

  const RegisterResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? RegisterDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }

  @override
  List<Object?> get props => [status, message, data];
}

/// Inner data model for registration response
class RegisterDataModel extends Equatable {
  final int id;
  final String email;
  final String fullName;
  final String? phone;
  final String? type;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  const RegisterDataModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.type,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory RegisterDataModel.fromJson(Map<String, dynamic> json) {
    return RegisterDataModel(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String?,
      type: json['type'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'type': type,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        phone,
        type,
        emailVerifiedAt,
        createdAt,
        updatedAt,
      ];
}
