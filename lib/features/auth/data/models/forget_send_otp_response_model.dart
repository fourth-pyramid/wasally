import 'package:wassaly/core/imports/packages_imports.dart';

class ForgetSendOtpResponseModel extends Equatable {
  final bool status;
  final String message;

  const ForgetSendOtpResponseModel({
    required this.status,
    required this.message,
  });

  factory ForgetSendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgetSendOtpResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }

  @override
  List<Object?> get props => [status, message];
}
