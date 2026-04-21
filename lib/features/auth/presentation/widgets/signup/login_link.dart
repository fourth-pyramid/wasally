import 'package:wassaly/core/imports/core_imports.dart';

class LoginLink extends StatelessWidget {
  final VoidCallback onLogin;

  const LoginLink({
    super.key,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'auth.already_have_account'.tr(),
          style: tt.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: onLogin,
          child: Text(
            'auth.log_in'.tr(),
            style: tt.bodyMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
