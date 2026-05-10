import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:wassaly/features/auth/presentation/widgets/forgot_password/forgot_password_email_field.dart';

class ForgotPasswordForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final ValueChanged<String> onEmailChanged;
  final VoidCallback onSubmit;

  const ForgotPasswordForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.onEmailChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ForgotPasswordEmailField(
            controller: emailController,
            onChanged: onEmailChanged,
            validator: (value) {
              if (value.isNullOrEmpty) {
                return 'auth.email_required'.tr();
              }
              if (!value!.isValidEmail && !value.isValidPhoneNumber) {
                return 'auth.email_invalid'.tr();
              }
              return null;
            },
          ),
          24.verticalSpace,
          BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
            buildWhen: (previous, current) =>
                previous.isLoading != current.isLoading,
            builder: (context, state) {
              return AppButton(
                label: 'auth.send_code'.tr(),
                onPressed: state.isLoading ? null : onSubmit,
                isLoading: state.isLoading,
                variant: ButtonVariant.success,
                isFullWidth: true,
                height: ButtonSize.medium,
                prefixIcon: Icon(
                  Icons.send_outlined,
                  color: cs.onPrimary,
                  size: 18.w,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
