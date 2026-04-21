import '../../imports/imports.dart';

/// A fully themed button supporting all [ButtonVariant]s and [ButtonSize]s.
///
/// Usage:
/// ```dart
/// AppButton(
///   label: 'Save',
///   onPressed: _save,
///   variant: ButtonVariant.primary,
///   size: ButtonSize.large,
///   isLoading: state.isLoading,
/// )
/// ```
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.color,
    this.textColor,
    this.height = ButtonSize.medium,
    this.width,
    this.isLoading = false,
    this.isFullWidth = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final Color? color;
  final Color? textColor;
  final ButtonSize height;
  final ButtonSize? width;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final appColors = context.theme.extension<AppColorsExtension>()!;
    final isDisabled = onPressed == null || isLoading;
    final isIOS = context.isIOS;

    final buttonHeight = switch (height) {
      ButtonSize.small => 36.h,
      ButtonSize.medium => 48.h,
      ButtonSize.large => 56.h,
    };

    final buttonWidth = switch (width) {
      ButtonSize.small => 100.w,
      ButtonSize.medium => 150.w,
      ButtonSize.large => 200.w,
      null => null,
    };

    final horizontalPadding = switch (height) {
      ButtonSize.small => 12.w,
      ButtonSize.medium => 20.w,
      ButtonSize.large => 28.w,
    };

    final fontSize = switch (height) {
      ButtonSize.small => 12.sp,
      ButtonSize.medium => 14.sp,
      ButtonSize.large => 16.sp,
    };

    final (bg, fg, border) = switch (variant) {
      ButtonVariant.primary => (
          color ?? cs.primary,
          color ?? cs.onPrimary,
          null
        ),
      ButtonVariant.secondary => (
          cs.secondaryContainer,
          cs.onSecondaryContainer,
          null
        ),
      ButtonVariant.outline => (
          Colors.transparent,
          cs.primary,
          BorderSide(color: cs.outline, width: 1.5)
        ),
      ButtonVariant.ghost => (Colors.transparent, cs.primary, null),
      ButtonVariant.danger => (cs.error, cs.onError, null),
      ButtonVariant.success => (appColors.success, appColors.onSuccess, null),
    };

    final Widget buttonChild = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: isIOS
                ? CupertinoActivityIndicator(color: fg)
                : CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(fg),
                  ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: context.theme.textTheme.labelLarge?.copyWith(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color:
                      isDisabled ? fg.withValues(alpha: 0.5) : textColor ?? fg,
                ),
              ),
              if (suffixIcon != null) ...[
                const SizedBox(width: 8),
                suffixIcon!,
              ],
            ],
          );

    if (isIOS) {
      return AnimatedOpacity(
        duration: AppDurations.fast,
        opacity: isDisabled ? 0.6 : 1.0,
        child: SizedBox(
          width: isFullWidth ? double.infinity : buttonWidth,
          height: buttonHeight,
          child: CupertinoButton(
            onPressed: isDisabled ? null : onPressed,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            color: bg,
            disabledColor: CupertinoColors.quaternarySystemFill,
            borderRadius: AppBorders.button,
            child: buttonChild,
          ),
        ),
      );
    }

    return AnimatedOpacity(
      duration: AppDurations.fast,
      opacity: isDisabled ? 0.6 : 1.0,
      child: SizedBox(
        width: isFullWidth ? double.infinity : buttonWidth,
        height: buttonHeight,
        child: TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            shape: border != null
                ? RoundedRectangleBorder(
                    borderRadius: AppBorders.button,
                    side: border,
                  )
                : const RoundedRectangleBorder(borderRadius: AppBorders.button),
          ),
          child: buttonChild,
        ),
      ),
    );
  }
}
