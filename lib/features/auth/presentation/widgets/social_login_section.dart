import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

import 'google_login_button.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: cs.outlineVariant,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                'auth.or_login_with'.tr(),
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: cs.outlineVariant,
                thickness: 1,
              ),
            ),
          ],
        ),
        20.verticalSpace,
        const GoogleLoginButton(),
      ],
    );
  }
}
