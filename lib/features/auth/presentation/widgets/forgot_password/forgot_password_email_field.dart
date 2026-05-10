import 'package:wassaly/core/imports/imports.dart';

class ForgotPasswordEmailField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  const ForgotPasswordEmailField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.validator,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'auth.email_or_phone'.tr(),
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        8.verticalSpace,
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: AppTextField(
            controller: controller,
            focusNode: focusNode,
            hint: 'example@wasally.com',
            onChanged: onChanged,
            validator: validator,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            prefixIcon: Icon(
              Icons.email_outlined,
              color: cs.onSurfaceVariant,
              size: 20.w,
            ),
          ),
        ),
      ],
    );
  }
}
