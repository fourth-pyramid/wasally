import '../../../../core/imports/imports.dart';

/// Model for OTP verification request body
class VerifyOtpRequestModel extends Equatable {
  final String email;
  final String code;

  const VerifyOtpRequestModel({
    required this.email,
    required this.code,
  });

  factory VerifyOtpRequestModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpRequestModel(
      email: json['email'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': code,
    };
  }

  @override
  List<Object?> get props => [email, code];
}
