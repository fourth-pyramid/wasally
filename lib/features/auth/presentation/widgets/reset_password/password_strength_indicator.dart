import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

/// A visual indicator showing password strength from 0 to 4 bars.
///
/// 0: Very Weak (Red)
/// 1: Weak (Orange)
/// 2: Fair (Yellow)
/// 3: Good (Light Green)
/// 4: Strong (Green)
class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
    this.showLabel = true,
  });

  final int strength;
  final bool showLabel;

  String _getStrengthLabel(BuildContext context) {
    switch (strength) {
      case 0:
        return 'reset_password.strength_very_weak'.tr();
      case 1:
        return 'reset_password.strength_weak'.tr();
      case 2:
        return 'reset_password.strength_fair'.tr();
      case 3:
        return 'reset_password.strength_good'.tr();
      case 4:
        return 'reset_password.strength_strong'.tr();
      default:
        return '';
    }
  }

  Color _getStrengthColor(BuildContext context) {
    final cs = context.theme.colorScheme;
    switch (strength) {
      case 0:
        return cs.error;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.amber;
      case 3:
        return Colors.lightGreen;
      case 4:
        return context.appColors.success;
      default:
        return cs.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final strengthColor = _getStrengthColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength bars
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 4.h,
                margin: EdgeInsets.only(right: index < 3 ? 4.w : 0),
                decoration: BoxDecoration(
                  color: index < strength
                      ? strengthColor
                      : cs.outline.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            );
          }),
        ),
        if (showLabel && strength > 0) ...[
          SizedBox(height: 8.h),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: context.theme.textTheme.bodySmall!.copyWith(
              color: strengthColor,
              fontWeight: FontWeight.w500,
            ),
            child: Text(_getStrengthLabel(context)),
          ),
        ],
      ],
    );
  }
}
