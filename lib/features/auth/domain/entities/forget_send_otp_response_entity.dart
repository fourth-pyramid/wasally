import 'package:wassaly/core/imports/packages_imports.dart';

class ForgetSendOtpResponseEntity extends Equatable {
  final bool status;
  final String message;

  const ForgetSendOtpResponseEntity({
    required this.status,
    required this.message,
  });

  @override
  List<Object?> get props => [status, message];
}
