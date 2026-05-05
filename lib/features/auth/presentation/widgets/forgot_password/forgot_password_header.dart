import 'package:wassaly/core/imports/imports.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      children: [
        60.verticalSpace,
        Text(
          'auth.forgot_password_title'.tr(),
          style: tt.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        12.verticalSpace,
        Text(
          'auth.forgot_password_subtitle'.tr(),
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        40.verticalSpace,
      ],
    );
  }
}
