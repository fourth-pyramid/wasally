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

  void _onLogin() {
    context.pop();
  }

  void _onTermsPressed() {
    context.push(AppRoutes.termsOfService);
  }

  void _onPrivacyPressed() {
    context.push(AppRoutes.privacyPolicy);
  }

  void _onAvatarSelected(File file) {
    context.read<SignupBloc>().add(AvatarChanged(file));
  }

  void _onAvatarCleared() {
    context.read<SignupBloc>().add(const AvatarChanged(null));
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
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SignupHeader(),
                15.verticalSpace,
                BlocBuilder<SignupBloc, SignupState>(
                  buildWhen: (previous, current) =>
                      previous.avatarFile != current.avatarFile,
                  builder: (context, state) {
                    return SignupForm(
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
                      onTermsPressed: _onTermsPressed,
                      onPrivacyPressed: _onPrivacyPressed,
                      avatarFile: state.avatarFile,
                      onAvatarSelected: _onAvatarSelected,
                      onAvatarCleared: _onAvatarCleared,
                    );
                  },
                ),
                15.verticalSpace,
                LoginLink(onLogin: _onLogin),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
