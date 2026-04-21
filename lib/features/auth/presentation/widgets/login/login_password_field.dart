import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/login/login_bloc.dart';

class LoginPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<bool> onToggleVisibility;
  final FormFieldValidator<String>? validator;

  const LoginPasswordField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onToggleVisibility,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.isPasswordVisible != current.isPasswordVisible,
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: AppTextField(
            controller: controller,
            onChanged: onChanged,
            validator: validator,
            obscureText: !state.isPasswordVisible,
            hint: '••••••••',
            prefixIcon: IconButton(
              onPressed: () => onToggleVisibility(state.isPasswordVisible),
              icon: Icon(
                state.isPasswordVisible
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
