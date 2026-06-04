import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/otp_verification/otp_verification_bloc.dart';

class ResendOtpWidget extends StatelessWidget {
  const ResendOtpWidget({
    required this.onResend,
    super.key,
  });

  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocSelector<OtpVerificationBloc, OtpVerificationState,
        (bool, int, bool, ResendOtpStatus)>(
      selector: (state) => (
        state.canResend,
        state.timerSeconds,
        state.isTimerRunning,
        state.resendStatus
      ),
      builder: (context, data) {
        final (canResend, timerSeconds, isTimerRunning, resendStatus) = data;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.l10n.otp_didnt_receive_code,
                  style: tt.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: canResend ? onResend : null,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: resendStatus == ResendOtpStatus.loading
                      ? const AppLoading(size: 16, strokeWidth: 2)
                      : Text(
                          context.l10n.otp_resend_code,
                          style: tt.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: canResend
                                ? cs.primary
                                : cs.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                        ),
                ),
              ],
            ),
            if (isTimerRunning) ...[
              4.verticalSpace,
              Text(
                context.l10n.otp_retry_after(timerSeconds),
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
