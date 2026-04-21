import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

class SignupPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;

  const SignupPhoneField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: AppTextField(
        controller: controller,
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
