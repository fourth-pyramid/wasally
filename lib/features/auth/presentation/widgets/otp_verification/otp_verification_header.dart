import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

class OtpVerificationHeader extends StatelessWidget {
  const OtpVerificationHeader({
    super.key,
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      children: [
        SizedBox(height: 60.h),
        Text(
          'auth.otp_verification_title'.tr(),
          style: tt.headlineMedium?.copyWith(
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: cs.primary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: tt.bodyLarge?.copyWith(
                fontSize: 16.sp,
                color: cs.onSurfaceVariant,
                height: 1.5,
              ),
              children: [
                TextSpan(text: 'otp.otp_sent_to'.tr()),
                TextSpan(
                  text: ' $email',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 40.h),
      ],
    );
  }
}
