import 'package:wassaly/core/imports/packages_imports.dart';

class ForgetVerifyOtpResponseModel extends Equatable {
  final bool status;
  final String message;
  final String? token;

  const ForgetVerifyOtpResponseModel({
    required this.status,
    required this.message,
    this.token,
  });

  factory ForgetVerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return ForgetVerifyOtpResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      token: data?['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'token': token,
    };
  }

  @override
  List<Object?> get props => [status, message, token];
}
