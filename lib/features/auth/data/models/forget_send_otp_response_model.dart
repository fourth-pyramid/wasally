import 'package:wassaly/features/auth/domain/entities/forget_send_otp_response_entity.dart';

class ForgetSendOtpResponseModel extends ForgetSendOtpResponseEntity {
  const ForgetSendOtpResponseModel({
    required super.status,
    required super.message,
  });

  factory ForgetSendOtpResponseModel.fromJson(Map<String, dynamic> json) => ForgetSendOtpResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );

  Map<String, dynamic> toJson() => {
      'status': status,
      'message': message,
    };
}
