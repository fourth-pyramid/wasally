import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

class BackToLoginLink extends StatelessWidget {
  final VoidCallback onPressed;

  const BackToLoginLink({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: cs.primary,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'auth.back_to_login'.tr(),
            style: tt.bodyLarge?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.arrow_back,
            size: 18.w,
            color: cs.primary,
          ),
        ],
      ),
    );
  }
}
