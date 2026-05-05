import 'package:wassaly/core/imports/imports.dart';

class LoginFormContainer extends StatelessWidget {
  final Widget child;

  const LoginFormContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
