import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

/// A themed text form field wrapping [TextFormField].
///
/// Usage:
/// ```dart
/// AppTextField(
///   label: 'Email',
///   hint: 'you@example.com',
///   controller: _emailController,
///   keyboardType: TextInputType.emailAddress,
///   validator: (v) => v!.isEmpty ? 'Required' : null,
/// )
/// ```
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.autofocus = false,
    this.filled = true,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.border = InputBorder.none,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final bool autofocus;
  final bool filled;
  final Color? fillColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final isIOS = context.isIOS;

    if (isIOS) {
      return CupertinoTextField(
        controller: controller,
        placeholder: hint,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        readOnly: readOnly,
        enabled: enabled,
        maxLines: obscureText ? 1 : maxLines,
        minLines: minLines,
        autofocus: autofocus,
        style: tt.bodyLarge?.copyWith(
          color: cs.onSurface,
        ),
        decoration: BoxDecoration(
          color: fillColor ?? const Color(0xFFF4F3F9),
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
        ),
        padding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
        prefix: prefixIcon != null
            ? Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: prefixIcon,
              )
            : null,
        suffix: suffixIcon != null
            ? Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: suffixIcon,
              )
            : null,
        onChanged: onChanged,
        onSubmitted: onFieldSubmitted,
        focusNode: focusNode,
        clearButtonMode: OverlayVisibilityMode.editing,
      );
    }

    return TextFormField(
      onTapUpOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: controller,
      initialValue: initialValue,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      autofocus: autofocus,
      style: tt.bodyLarge?.copyWith(
        color: cs.onSurface,
      ),
      cursorColor: cs.primary,
      decoration: InputDecoration(
        isDense: true,
        filled: filled,
        fillColor: fillColor ?? const Color(0xFFF4F3F9),
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: prefixIcon,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: suffixIcon,
              )
            : null,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border,
        disabledBorder: border,
        focusedErrorBorder: border,
      ),
    );
  }
}
