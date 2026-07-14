import 'package:wassaly/core/imports/packages_imports.dart';

class ForgetVerifyOtpResponseEntity extends Equatable {
  final bool status;
  final String message;
  final String? token;

  const ForgetVerifyOtpResponseEntity({
    required this.status,
    required this.message,
    this.token,
  });

  @override
  List<Object?> get props => [status, message, token];
}
