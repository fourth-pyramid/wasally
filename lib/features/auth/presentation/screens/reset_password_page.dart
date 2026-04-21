import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/injection/injection.dart';
import 'package:wassaly/features/auth/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:wassaly/features/auth/presentation/widgets/reset_password/reset_password_form.dart';

/// Route arguments for ResetPasswordPage.
/// Passed via GoRouter's extra parameter.
class ResetPasswordArgs {
  final String email;
  final String otp;

  const ResetPasswordArgs({
    required this.email,
    required this.otp,
  });
}

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ResetPasswordBloc>(
        param1: email,
        param2: otp,
      ),
      child: _ResetPasswordView(email: email),
    );
  }
}

class _ResetPasswordView extends StatelessWidget {
  const _ResetPasswordView({
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        // Handle success
        if (state.status == ResetPasswordStatus.success) {
          context.showSuccessSnackBar('reset_password.success_message'.tr());
          // Navigate to login and clear the navigation stack
          context.go(AppRoutes.login);
        }

        // Handle error
        if (state.status == ResetPasswordStatus.error &&
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
                // Header Icon
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset_outlined,
                    color: cs.primary,
                    size: 40.w,
                  ),
                ),
                SizedBox(height: 24.h),

                // Title
                Text(
                  'reset_password.title'.tr(),
                  style: context.theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),

                // Subtitle with email
                Text(
                  'reset_password.subtitle'.tr(),
                  style: context.theme.textTheme.bodyLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                Text(
                  email.maskEmail,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),

                // Password Requirements Hint
                BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                  buildWhen: (previous, current) =>
                      previous.isNewPasswordValid !=
                          current.isNewPasswordValid ||
                      previous.isConfirmPasswordValid !=
                          current.isConfirmPasswordValid,
                  builder: (context, state) {
                    return Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                            color: cs.outline.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'reset_password.requirements_title'.tr(),
                            style: context.theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          _buildRequirementRow(
                            context,
                            'reset_password.req_min_length'.tr(),
                            isMet: state.isNewPasswordValid,
                          ),
                          SizedBox(height: 8.h),
                          _buildRequirementRow(
                            context,
                            'reset_password.req_match'.tr(),
                            isMet: state.isConfirmPasswordValid,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 24.h),

                // Form
                const ResetPasswordForm(),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementRow(
    BuildContext context,
    String text, {
    required bool isMet,
  }) {
    final cs = context.theme.colorScheme;
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isMet ? Icons.check_circle : Icons.check_circle_outline,
            key: ValueKey<bool>(isMet),
            color: isMet ? Colors.green : cs.onSurfaceVariant,
            size: 16.w,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: isMet ? Colors.green : cs.onSurfaceVariant,
              fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
