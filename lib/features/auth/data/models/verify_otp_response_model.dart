import '../../../../core/imports/imports.dart';

/// Model for OTP verification API response
class VerifyOtpResponseModel extends Equatable {
  final bool status;
  final String message;
  final VerifyOtpDataModel? data;

  const VerifyOtpResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? VerifyOtpDataModel.fromJson(json['data'] as Map<String, dynamic>)
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

/// Inner data model for OTP verification response
class VerifyOtpDataModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? type;

  const VerifyOtpDataModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.type,
  });

  factory VerifyOtpDataModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpDataModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'type': type,
    };
  }

  @override
  List<Object?> get props => [id, name, email, phone, avatar, type];
}
