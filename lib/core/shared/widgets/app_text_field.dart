import 'package:wassaly/core/imports/imports.dart';

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
class AppTextField extends StatefulWidget {
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
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final isIOS = context.isIOS;

    if (isIOS) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            Padding(
              padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
              child: Text(
                widget.label!,
                style: tt.labelMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          CupertinoTextField(
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            controller: widget.controller,
            placeholder: widget.hint,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.obscureText,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            minLines: widget.minLines,
            autofocus: widget.autofocus,
            style: tt.bodyLarge?.copyWith(
              color: cs.onSurface,
            ),
            decoration: BoxDecoration(
              color: widget.fillColor ??
                  cs.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
              border: _errorText != null
                  ? Border.all(color: cs.error, width: 1)
                  : null,
            ),
            padding: widget.contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
            prefix: widget.prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: widget.prefixIcon,
                  )
                : null,
            suffix: widget.suffixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: widget.suffixIcon,
                  )
                : null,
            onChanged: (value) {
              if (widget.validator != null) {
                setState(() {
                  _errorText = widget.validator!(value);
                });
              }
              widget.onChanged?.call(value);
            },
            onSubmitted: widget.onFieldSubmitted,
            focusNode: widget.focusNode,
            clearButtonMode: OverlayVisibilityMode.editing,
          ),
          if (_errorText != null)
            Padding(
              padding: EdgeInsets.only(left: 12.w, top: 4.h),
              child: Text(
                _errorText!,
                style: tt.bodySmall?.copyWith(color: cs.error),
              ),
            ),
        ],
      );
    }

    return TextFormField(
      onTapUpOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: widget.controller,
      initialValue: widget.initialValue,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      autofocus: widget.autofocus,
      style: tt.bodyLarge?.copyWith(
        color: cs.onSurface,
      ),
      cursorColor: cs.primary,
      decoration: InputDecoration(
        isDense: true,
        filled: widget.filled,
        fillColor: widget.fillColor ??
            cs.surfaceContainerHighest.withValues(alpha: 0.5),
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: widget.prefixIcon,
              )
            : null,
        suffixIcon: widget.suffixIcon != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: widget.suffixIcon,
              )
            : null,
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: cs.error),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
      ),
    );
  }
}
