import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:wassaly/features/auth/presentation/widgets/reset_password/password_strength_indicator.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _onNewPasswordChanged(String value) {
    context.read<ResetPasswordBloc>().add(NewPasswordChanged(value));
  }

  void _onConfirmPasswordChanged(String value) {
    context.read<ResetPasswordBloc>().add(ConfirmPasswordChanged(value));
  }

  void _onToggleNewPasswordVisibility() {
    context.read<ResetPasswordBloc>().add(
          const PasswordVisibilityToggled(isNewPassword: true),
        );
  }

  void _onToggleConfirmPasswordVisibility() {
    context.read<ResetPasswordBloc>().add(
          const PasswordVisibilityToggled(isNewPassword: false),
        );
  }

  void _onSubmit() {
    context.hideKeyboard();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ResetPasswordBloc>().add(const ResetPasswordSubmitted());
    }
  }

  String? _validateNewPassword(String? value, ResetPasswordState state) {
    if (value == null || value.isEmpty) {
      return 'auth.password_required'.tr();
    }
    if (value.length < 8) {
      return state.newPasswordError?.tr();
    }
    return null;
  }

  String? _validateConfirmPassword(String? value, ResetPasswordState state) {
    if (value == null || value.isEmpty) {
      return 'auth.confirm_password_required'.tr();
    }
    if (value != state.newPassword) {
      return state.confirmPasswordError?.tr();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
      buildWhen: (previous, current) =>
          previous.newPassword != current.newPassword ||
          previous.confirmPassword != current.confirmPassword ||
          previous.isNewPasswordVisible != current.isNewPasswordVisible ||
          previous.isConfirmPasswordVisible !=
              current.isConfirmPasswordVisible ||
          previous.status != current.status,
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // New Password Field
              Text(
                'auth.password'.tr(),
                style: context.theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              AppTextField(
                hint: 'reset_password.new_password_hint'.tr(),
                obscureText: !state.isNewPasswordVisible,
                onChanged: _onNewPasswordChanged,
                onFieldSubmitted: (_) =>
                    _confirmPasswordFocusNode.requestFocus(),
                focusNode: _newPasswordFocusNode,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => _validateNewPassword(value, state),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: cs.onSurfaceVariant,
                  size: 20.w,
                ),
                suffixIcon: GestureDetector(
                  onTap: _onToggleNewPasswordVisibility,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      state.isNewPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      key: ValueKey<bool>(state.isNewPasswordVisible),
                      color: cs.onSurfaceVariant,
                      size: 20.w,
                    ),
                  ),
                ),
              ),

              // Password Strength Indicator
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: state.newPassword.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: PasswordStrengthIndicator(
                          strength: state.passwordStrength,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              SizedBox(height: 24.h),

              // Confirm Password Field
              Text(
                'auth.confirm_password'.tr(),
                style: context.theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              AppTextField(
                hint: 'reset_password.confirm_password_hint'.tr(),
                obscureText: !state.isConfirmPasswordVisible,
                onChanged: _onConfirmPasswordChanged,
                onFieldSubmitted: (_) => _onSubmit(),
                focusNode: _confirmPasswordFocusNode,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => _validateConfirmPassword(value, state),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: cs.onSurfaceVariant,
                  size: 20.w,
                ),
                suffixIcon: GestureDetector(
                  onTap: _onToggleConfirmPasswordVisibility,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      state.isConfirmPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      key: ValueKey<bool>(state.isConfirmPasswordVisible),
                      color: cs.onSurfaceVariant,
                      size: 20.w,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // Submit Button
              AppButton(
                label: 'reset_password.reset_button'.tr(),
                onPressed: state.canSubmit ? _onSubmit : null,
                isLoading: state.status == ResetPasswordStatus.loading,
                isFullWidth: true,
                height: ButtonSize.medium,
                variant: ButtonVariant.success,
                suffixIcon: state.status != ResetPasswordStatus.loading
                    ? Icon(
                        Icons.lock_reset_outlined,
                        color: cs.onPrimary,
                        size: 24.w,
                      )
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
