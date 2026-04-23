import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/signup/signup_bloc.dart';

class SignupPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<bool> onToggleVisibility;
  final FormFieldValidator<String>? validator;
  final bool isConfirmPassword;

  const SignupPasswordField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onToggleVisibility,
    this.validator,
    this.isConfirmPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => isConfirmPassword
          ? previous.isConfirmPasswordVisible !=
              current.isConfirmPasswordVisible
          : previous.isPasswordVisible != current.isPasswordVisible,
      builder: (context, state) {
        final isVisible = isConfirmPassword
            ? state.isConfirmPasswordVisible
            : state.isPasswordVisible;
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: AppTextField(
            controller: controller,
            onChanged: onChanged,
            validator: validator,
            obscureText: !isVisible,
            textInputAction: TextInputAction.done,
            hint: '••••••••',
            prefixIcon: IconButton(
              onPressed: () => onToggleVisibility(isVisible),
              icon: Icon(
                isVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: cs.onSurfaceVariant,
                size: 20.sp,
              ),
            ),
          ),
        );
      },
    );
  }
}
