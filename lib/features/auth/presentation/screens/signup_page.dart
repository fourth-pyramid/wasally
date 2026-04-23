import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/injection/injection.dart';
import 'package:wassaly/features/auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:wassaly/features/auth/presentation/widgets/signup/login_link.dart';
import 'package:wassaly/features/auth/presentation/widgets/signup/signup_form.dart';
import 'package:wassaly/features/auth/presentation/widgets/signup/signup_header.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignupBloc>(),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatefulWidget {
  const _SignupView();

  @override
  State<_SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<_SignupView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onNameChanged(String value) {
    context.read<SignupBloc>().add(NameChanged(value));
  }

  void _onPhoneChanged(String value) {
    context.read<SignupBloc>().add(PhoneChanged(value));
  }

  void _onEmailChanged(String value) {
    context.read<SignupBloc>().add(EmailChanged(value));
  }

  void _onPasswordChanged(String value) {
    context.read<SignupBloc>().add(PasswordChanged(value));
  }

  void _onTogglePasswordVisibility(bool isVisible) {
    context.read<SignupBloc>().add(PasswordVisibilityChanged(!isVisible));
  }

  void _onConfirmPasswordChanged(String value) {
    context.read<SignupBloc>().add(ConfirmPasswordChanged(value));
  }

  void _onToggleConfirmPasswordVisibility(bool isVisible) {
    context
        .read<SignupBloc>()
        .add(ConfirmPasswordVisibilityChanged(!isVisible));
  }

  void _onSignup() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SignupBloc>().add(const SignupSubmitted());
    }
  }

  void _onSignupWithGoogle() {
    context.read<SignupBloc>().add(const SignupWithGoogle());
  }

  void _onSignupWithFacebook() {
    context.read<SignupBloc>().add(const SignupWithFacebook());
  }

  void _onLogin() {
    context.pop();
  }

  void _onTermsPressed() {
    // TODO: Navigate to terms of service
  }

  void _onPrivacyPressed() {
    // TODO: Navigate to privacy policy
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listenWhen: (previous, current) =>
          previous.isRegistered != current.isRegistered ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.isRegistered) {
          context.showSuccessSnackBar('تم ارسال كود التحقق بنجاح');
          context.push(
            AppRoutes.otpVerification,
            extra: {
              'email': state.email,
              'verificationType': VerificationType.register,
            },
          );
        }
        if (state.errorMessage != null) {
          context.showErrorSnackBar(state.errorMessage!);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SignupHeader(),
                SizedBox(height: 15.h),
                SignupForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  phoneController: _phoneController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  onNameChanged: _onNameChanged,
                  onPhoneChanged: _onPhoneChanged,
                  onEmailChanged: _onEmailChanged,
                  onPasswordChanged: _onPasswordChanged,
                  onTogglePasswordVisibility: _onTogglePasswordVisibility,
                  onConfirmPasswordChanged: _onConfirmPasswordChanged,
                  onToggleConfirmPasswordVisibility:
                      _onToggleConfirmPasswordVisibility,
                  onSignup: _onSignup,
                  onSignupWithGoogle: _onSignupWithGoogle,
                  onSignupWithFacebook: _onSignupWithFacebook,
                  onTermsPressed: _onTermsPressed,
                  onPrivacyPressed: _onPrivacyPressed,
                ),
                SizedBox(height: 15.h),
                LoginLink(onLogin: _onLogin),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
