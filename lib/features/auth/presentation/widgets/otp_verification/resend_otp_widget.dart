import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/otp_verification/otp_verification_bloc.dart';

class ResendOtpWidget extends StatelessWidget {
  const ResendOtpWidget({
    super.key,
    required this.onResend,
  });

  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
      buildWhen: (previous, current) =>
          previous.canResend != current.canResend ||
          previous.timerSeconds != current.timerSeconds ||
          previous.isTimerRunning != current.isTimerRunning ||
          previous.resendStatus != current.resendStatus,
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'otp.didnt_receive_code'.tr(),
                  style: tt.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: state.canResend ? onResend : null,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: state.resendStatus == ResendOtpStatus.loading
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.primary,
                          ),
                        )
                      : Text(
                          'otp.resend_code'.tr(),
                          style: tt.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: state.canResend
                                ? cs.primary
                                : cs.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                        ),
                ),
              ],
            ),
            if (state.isTimerRunning) ...[
              SizedBox(height: 4.h),
              Text(
                'otp.retry_after'
                    .tr(namedArgs: {'timer': state.formattedTimer}),
                style: tt.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
