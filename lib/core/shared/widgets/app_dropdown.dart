import 'package:wassaly/core/imports/imports.dart';

/// A themed dropdown button form field wrapping [DropdownButtonFormField]
/// or [CupertinoPicker] for iOS.
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
    this.focusNode,
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
  final FocusNode? focusNode;

  void _showIOSPicker(BuildContext context, cs, tt) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250.h,
          padding: EdgeInsets.only(top: 6.h),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          color: cs.surface,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      child: Text(
                        'done'.tr(),
                        style: tt.labelLarge?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 32,
                    scrollController: FixedExtentScrollController(
                      initialItem: items.indexWhere(
                        (item) => item.value == value,
                      ),
                    ),
                    onSelectedItemChanged: (int index) {
                      if (onChanged != null) {
                        onChanged!(items[index].value);
                      }
                    },
                    children:
                        items.map((item) => Center(child: item.child)).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final radius = borderRadius ?? 12.r;
    final isIOS = context.isIOS;

    if (isIOS) {
      final selectedItem = items.firstWhere(
        (item) => item.value == value,
        orElse: () => items.first,
      );

      return GestureDetector(
        onTap: enabled ? () => _showIOSPicker(context, cs, tt) : null,
        child: Container(
          padding: contentPadding ??
              EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
          decoration: BoxDecoration(
            color: fillColor ??
                (enabled
                    ? cs.surfaceContainerHighest.withValues(alpha: 0.5)
                    : cs.surfaceContainerHighest.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                12.horizontalSpace,
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (label != null)
                      Text(
                        label!,
                        style: tt.labelMedium?.copyWith(
                          color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                    if (value != null)
                      DefaultTextStyle(
                        style: tt.bodyLarge!.copyWith(
                          color: enabled
                              ? cs.onSurface
                              : cs.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                        child: selectedItem.child,
                      )
                    else if (hint != null)
                      Text(
                        hint!,
                        style: tt.bodyLarge?.copyWith(
                          color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                      ),
                  ],
                ),
              ),
              suffixIcon ??
                  Icon(
                    CupertinoIcons.chevron_down,
                    size: 18,
                    color: enabled
                        ? cs.onSurfaceVariant
                        : cs.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
            ],
          ),
        ),
      );
    }

    return DropdownButtonFormField<T>(
      focusNode: focusNode,
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
