import 'package:wassaly/core/imports/imports.dart';

class EditProfilePhoneField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  const EditProfilePhoneField({
    super.key,
    required this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: 'auth.phone'.tr(),
      hint: 'auth.phone'.tr(),
      controller: controller,
      focusNode: focusNode,
      prefixIcon: const Icon(Icons.phone_outlined),
      keyboardType: TextInputType.phone,
    );
  }
}
