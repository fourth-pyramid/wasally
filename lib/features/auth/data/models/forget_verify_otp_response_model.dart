import 'package:wassaly/features/auth/domain/entities/forget_verify_otp_response_entity.dart';

class ForgetVerifyOtpResponseModel extends ForgetVerifyOtpResponseEntity {
  const ForgetVerifyOtpResponseModel({
    required super.status,
    required super.message,
    super.token,
  });

  factory ForgetVerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return ForgetVerifyOtpResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      token: data?['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
      'status': status,
      'message': message,
      'token': token,
    };
}
