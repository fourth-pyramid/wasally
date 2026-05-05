import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:wassaly/features/auth/presentation/widgets/signup/avatar_picker_widget.dart';
import 'package:wassaly/features/auth/presentation/widgets/signup/signup_email_field.dart';
import 'package:wassaly/features/auth/presentation/widgets/signup/signup_form_container.dart';
import 'package:wassaly/features/auth/presentation/widgets/signup/signup_name_field.dart';
import 'package:wassaly/features/auth/presentation/widgets/signup/signup_password_field.dart';
import 'package:wassaly/features/auth/presentation/widgets/signup/signup_phone_field.dart';
import 'package:wassaly/features/auth/presentation/widgets/signup/signup_terms_checkbox.dart';
import 'package:wassaly/features/auth/presentation/widgets/social_login_section.dart';

class SignupForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<bool> onTogglePasswordVisibility;
  final ValueChanged<String> onConfirmPasswordChanged;
  final ValueChanged<bool> onToggleConfirmPasswordVisibility;
  final VoidCallback onSignup;
  final VoidCallback onTermsPressed;
  final VoidCallback onPrivacyPressed;
  final File? avatarFile;
  final VoidCallback onAvatarCleared;
  final void Function(File) onAvatarSelected;

  const SignupForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onNameChanged,
    required this.onPhoneChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onTogglePasswordVisibility,
    required this.onConfirmPasswordChanged,
    required this.onToggleConfirmPasswordVisibility,
    required this.onSignup,
    required this.onTermsPressed,
    required this.onPrivacyPressed,
    this.avatarFile,
    required this.onAvatarCleared,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      children: [
        AvatarPickerWidget(
          avatarFile: avatarFile,
          onAvatarCleared: onAvatarCleared,
          onAvatarSelected: onAvatarSelected,
        ),
        20.verticalSpace,
        Form(
          key: formKey,
          child: SignupFormContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'auth.name'.tr(),
                  textAlign: TextAlign.start,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                12.verticalSpace,
                SignupNameField(
                  controller: nameController,
                  onChanged: onNameChanged,
                  validator: (value) {
                    if (value.isNullOrEmpty) {
                      return 'auth.name_required'.tr();
                    }
                    return null;
                  },
                ),
                16.verticalSpace,
                Text(
                  'auth.phone'.tr(),
                  textAlign: TextAlign.start,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                12.verticalSpace,
                SignupPhoneField(
                  controller: phoneController,
                  onChanged: onPhoneChanged,
                  validator: (value) {
                    if (value.isNullOrEmpty) {
                      return 'auth.phone_required'.tr();
                    }
                    if (!value!.isValidPhoneNumber) {
                      return 'auth.phone_invalid'.tr();
                    }
                    return null;
                  },
                ),
                16.verticalSpace,
                Text(
                  'auth.email'.tr(),
                  textAlign: TextAlign.start,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                12.verticalSpace,
                SignupEmailField(
                  controller: emailController,
                  onChanged: onEmailChanged,
                  validator: (value) {
                    if (value.isNullOrEmpty) {
                      return 'auth.email_required'.tr();
                    }
                    if (!value!.isValidEmail) {
                      return 'auth.email_invalid'.tr();
                    }
                    return null;
                  },
                ),
                16.verticalSpace,
                Text(
                  'auth.password'.tr(),
                  textAlign: TextAlign.start,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                12.verticalSpace,
                SignupPasswordField(
                  controller: passwordController,
                  onChanged: onPasswordChanged,
                  onToggleVisibility: onTogglePasswordVisibility,
                  validator: (value) {
                    if (value.isNullOrEmpty) {
                      return 'auth.password_required'.tr();
                    }
                    if (value!.length < 6) {
                      return 'auth.password_too_short'.tr();
                    }
                    return null;
                  },
                ),
                16.verticalSpace,
                Text(
                  'auth.confirm_password'.tr(),
                  textAlign: TextAlign.start,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                12.verticalSpace,
                SignupPasswordField(
                  controller: confirmPasswordController,
                  onChanged: onConfirmPasswordChanged,
                  onToggleVisibility: onToggleConfirmPasswordVisibility,
                  isConfirmPassword: true,
                  validator: (value) {
                    if (value.isNullOrEmpty) {
                      return 'auth.confirm_password_required'.tr();
                    }
                    if (value != passwordController.text) {
                      return 'auth.passwords_do_not_match'.tr();
                    }
                    return null;
                  },
                ),
                16.verticalSpace,
                SignupTermsCheckbox(
                  onTermsPressed: onTermsPressed,
                  onPrivacyPressed: onPrivacyPressed,
                ),
                20.verticalSpace,
                BlocBuilder<SignupBloc, SignupState>(
                  buildWhen: (previous, current) =>
                      previous.isLoading != current.isLoading ||
                      previous.isTermsAccepted != current.isTermsAccepted,
                  builder: (context, state) {
                    return AppButton(
                      label: 'auth.create_account_button'.tr(),
                      onPressed: (state.isLoading || !state.isTermsAccepted)
                          ? null
                          : onSignup,
                      isLoading: state.isLoading,
                      variant: ButtonVariant.success,
                      isFullWidth: true,
                      height: ButtonSize.medium,
                    );
                  },
                ),
                20.verticalSpace,
                const SocialLoginSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
