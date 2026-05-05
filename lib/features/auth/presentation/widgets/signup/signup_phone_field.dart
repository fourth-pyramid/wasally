import 'package:wassaly/core/imports/imports.dart';

class SignupPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  const SignupPhoneField({
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
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        hint: '+201XXXXXXXXX',
        prefixIcon: Icon(
          Icons.phone_outlined,
          color: cs.onSurfaceVariant,
          size: 20.sp,
        ),
      ),
    );
  }
}
