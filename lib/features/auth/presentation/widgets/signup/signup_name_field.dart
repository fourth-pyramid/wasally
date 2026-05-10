import 'package:wassaly/core/imports/imports.dart';

class SignupNameField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  const SignupNameField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.validator,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: AppTextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        validator: validator,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        hint: 'auth.name_placeholder'.tr(),
        prefixIcon: Icon(
          Icons.person_outline,
          color: cs.onSurfaceVariant,
          size: 20.sp,
        ),
      ),
    );
  }
}
