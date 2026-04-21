import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/injection/injection.dart';
import 'package:wassaly/features/auth/presentation/bloc/otp_verification/otp_verification_bloc.dart';
import 'package:wassaly/features/auth/presentation/screens/reset_password_page.dart';
import 'package:wassaly/features/auth/presentation/widgets/otp_verification/otp_input_field.dart';
import 'package:wassaly/features/auth/presentation/widgets/otp_verification/otp_verification_header.dart';
import 'package:wassaly/features/auth/presentation/widgets/otp_verification/resend_otp_widget.dart';

class OtpVerificationPage extends StatelessWidget {
  const OtpVerificationPage({
    super.key,
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OtpVerificationBloc>(param1: email),
      child: _OtpVerificationView(email: email),
    );
  }
}

class _OtpVerificationView extends StatefulWidget {
  const _OtpVerificationView({
    required this.email,
  });

  final String email;

  @override
  State<_OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<_OtpVerificationView> {
  final GlobalKey<OtpInputFieldState> _otpInputKey =
      GlobalKey<OtpInputFieldState>();
  String _currentOtp = '';

  void _onOtpChanged(String otp) {
    _currentOtp = otp;
    context.read<OtpVerificationBloc>().add(OtpDigitChanged(otp));
  }

  void _onOtpCompleted(String otp) {
    _currentOtp = otp;
    context.read<OtpVerificationBloc>().add(OtpDigitChanged(otp));
    context.hideKeyboard();
  }

  void _onVerifyPressed() {
    if (_currentOtp.length == 6) {
      context.read<OtpVerificationBloc>().add(const VerifyOtpSubmitted());
    }
  }

  void _onResendPressed() {
    context.read<OtpVerificationBloc>().add(const ResendOtpRequested());
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocListener<OtpVerificationBloc, OtpVerificationState>(
      listenWhen: (previous, current) =>
          previous.verificationStatus != current.verificationStatus ||
          previous.errorMessage != current.errorMessage ||
          previous.resendStatus != current.resendStatus,
      listener: (context, state) {
        if (state.verificationStatus == OtpVerificationStatus.verified) {
          context.showSuccessSnackBar('otp.verification_success'.tr());
          // Navigate to reset password page with email and OTP
          context.push(
            AppRoutes.resetPassword,
            extra: ResetPasswordArgs(
              email: state.email,
              otp: state.otp,
            ),
          );
        }

        if (state.verificationStatus == OtpVerificationStatus.error &&
            state.errorMessage != null) {
          context.showErrorSnackBar(state.errorMessage!.tr());
        }

        if (state.resendStatus == ResendOtpStatus.success) {
          context.showSuccessSnackBar('otp.resend_success'.tr());
        }

        if (state.resendStatus == ResendOtpStatus.error &&
            state.errorMessage != null) {
          context.showErrorSnackBar(state.errorMessage!.tr());
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OtpVerificationHeader(email: widget.email),
                OtpInputField(
                  key: _otpInputKey,
                  length: 6,
                  onChanged: _onOtpChanged,
                  onCompleted: _onOtpCompleted,
                  autoFocus: true,
                ),
                SizedBox(height: 32.h),
                ResendOtpWidget(onResend: _onResendPressed),
                SizedBox(height: 40.h),
                BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
                  buildWhen: (previous, current) =>
                      previous.canVerify != current.canVerify ||
                      previous.verificationStatus != current.verificationStatus,
                  builder: (context, state) {
                    return AppButton(
                      label: 'otp.verify_now'.tr(),
                      onPressed: state.canVerify ? _onVerifyPressed : null,
                      isLoading: state.verificationStatus ==
                          OtpVerificationStatus.loading,
                      isFullWidth: true,
                      height: ButtonSize.medium,
                      variant: ButtonVariant.success,
                      suffixIcon: state.verificationStatus !=
                              OtpVerificationStatus.loading
                          ? Icon(
                              Icons.verified_outlined,
                              color: cs.onPrimary,
                              size: 24.w,
                            )
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
