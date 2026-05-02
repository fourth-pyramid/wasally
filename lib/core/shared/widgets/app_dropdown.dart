import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

/// A themed dropdown button form field wrapping [DropdownButtonFormField].
///
/// Usage:
/// ```dart
/// AppDropdown<String>(
///   label: 'Governorate',
///   prefixIcon: Icon(Icons.map_outlined),
///   value: _selectedValue,
///   items: governorates.map((g) {
///     return DropdownMenuItem(
///       value: g.id,
///       child: Text(g.name),
///     );
///   }).toList(),
///   onChanged: (value) => setState(() => _selectedValue = value),
///   validator: (v) => v == null ? 'Required' : null,
/// )
/// ```
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor,
    this.contentPadding,
    this.borderRadius,
    this.enabled = true,
    this.isExpanded = true,
    this.alignment = AlignmentDirectional.centerStart,
    this.menuMaxHeight,
    this.elevation = 8,
  });

  final String? label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final bool enabled;
  final bool isExpanded;
  final AlignmentGeometry alignment;
  final double? menuMaxHeight;
  final int elevation;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final radius = borderRadius ?? 12.r;

    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      isExpanded: isExpanded,
      alignment: alignment,
      menuMaxHeight: menuMaxHeight,
      elevation: elevation,
      dropdownColor: cs.surfaceContainerLowest,
      icon: suffixIcon ??
          Icon(
            Icons.arrow_drop_down,
            color: enabled
                ? cs.onSurface
                : cs.onSurfaceVariant.withValues(alpha: 0.5),
          ),
      style: tt.bodyLarge?.copyWith(
        color:
            enabled ? cs.onSurface : cs.onSurfaceVariant.withValues(alpha: 0.5),
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: fillColor ??
            (enabled
                ? cs.surfaceContainerHighest.withValues(alpha: 0.5)
                : cs.surfaceContainerHighest.withValues(alpha: 0.2)),
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
        labelStyle: tt.labelMedium?.copyWith(
          color: cs.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        hintStyle: tt.labelMedium?.copyWith(
          color: cs.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
