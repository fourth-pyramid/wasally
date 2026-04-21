import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/signup/signup_bloc.dart';
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
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<bool> onTogglePasswordVisibility;
  final VoidCallback onSignup;
  final VoidCallback onSignupWithGoogle;
  final VoidCallback onSignupWithFacebook;
  final VoidCallback onTermsPressed;
  final VoidCallback onPrivacyPressed;

  const SignupForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.onNameChanged,
    required this.onPhoneChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onTogglePasswordVisibility,
    required this.onSignup,
    required this.onSignupWithGoogle,
    required this.onSignupWithFacebook,
    required this.onTermsPressed,
    required this.onPrivacyPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Form(
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
            SizedBox(height: 12.h),
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
            SizedBox(height: 16.h),
            Text(
              'auth.phone'.tr(),
              textAlign: TextAlign.start,
              style: tt.bodyMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 12.h),
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
            SizedBox(height: 16.h),
            Text(
              'auth.email'.tr(),
              textAlign: TextAlign.start,
              style: tt.bodyMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 12.h),
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
            SizedBox(height: 16.h),
            Text(
              'auth.password'.tr(),
              textAlign: TextAlign.start,
              style: tt.bodyMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 12.h),
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
            SizedBox(height: 16.h),
            SignupTermsCheckbox(
              onTermsPressed: onTermsPressed,
              onPrivacyPressed: onPrivacyPressed,
            ),
            SizedBox(height: 20.h),
            BlocBuilder<SignupBloc, SignupState>(
              buildWhen: (previous, current) =>
                  previous.isLoading != current.isLoading,
              builder: (context, state) {
                return AppButton(
                  label: 'auth.create_account_button'.tr(),
                  onPressed: state.isLoading ? null : onSignup,
                  isLoading: state.isLoading,
                  variant: ButtonVariant.success,
                  isFullWidth: true,
                  height: ButtonSize.medium,
                );
              },
            ),
            SizedBox(height: 20.h),
            SocialLoginSection(
              onLoginWithGoogle: onSignupWithGoogle,
              onLoginWithFacebook: onSignupWithFacebook,
            ),
          ],
        ),
      ),
    );
  }
}
