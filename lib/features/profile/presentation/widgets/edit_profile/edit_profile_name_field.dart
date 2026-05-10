import 'package:wassaly/core/imports/imports.dart';

class EditProfileNameField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;

  const EditProfileNameField({
    super.key,
    required this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: 'auth.name'.tr(),
      hint: 'auth.name_placeholder'.tr(),
      controller: controller,
      focusNode: focusNode,
      prefixIcon: const Icon(Icons.person_outline),
      validator: (v) => v!.isEmpty ? 'auth.name_required'.tr() : null,
    );
  }
}
