import 'package:wassaly/core/imports/imports.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.backgroundColor,
    required this.foregroundColor,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
              ),
            )
          else ...[
            Text(
              label,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            8.horizontalSpace,
            SvgPicture.asset(
              iconPath,
              width: 20.w,
              height: 20.h,
              colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn),
            ),
          ],
        ],
      ),
    );
  }
}
