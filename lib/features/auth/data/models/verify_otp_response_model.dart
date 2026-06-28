import 'package:wassaly/features/auth/domain/entities/verify_otp_response_entity.dart';

/// Model for OTP verification API response
class VerifyOtpResponseModel extends VerifyOtpResponseEntity {
  const VerifyOtpResponseModel({
    required super.status,
    required super.message,
    super.data,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) => VerifyOtpResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? VerifyOtpDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );

  Map<String, dynamic> toJson() => {
      'status': status,
      'message': message,
      'data': (data as VerifyOtpDataModel?)?.toJson(),
    };
}

/// Inner data model for OTP verification response
class VerifyOtpDataModel extends VerifyOtpUserDataEntity {
  const VerifyOtpDataModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.avatar,
    super.type,
  });

  factory VerifyOtpDataModel.fromJson(Map<String, dynamic> json) => VerifyOtpDataModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      type: json['type'] as String?,
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'type': type,
    };
}
