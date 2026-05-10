import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:wassaly/features/auth/presentation/widgets/login/create_account_link.dart';
import 'package:wassaly/features/auth/presentation/widgets/login/login_form.dart';
import 'package:wassaly/features/auth/presentation/widgets/login/login_header.dart';

import '../bloc/session/session_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    context.read<LoginBloc>().add(EmailChanged(value));
  }

  void _onPasswordChanged(String value) {
    context.read<LoginBloc>().add(PasswordChanged(value));
  }

  void _onTogglePasswordVisibility(bool isVisible) {
    context.read<LoginBloc>().add(PasswordVisibilityChanged(!isVisible));
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginBloc>().add(const LoginSubmitted());
    }
  }

  void _onForgotPassword() {
    context.push(AppRoutes.forgotPassword);
  }

  void _onCreateAccount() {
    context.push(AppRoutes.signup);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          previous.user != current.user ||
          previous.errorMessage != current.errorMessage ||
          previous.requiresVerification != current.requiresVerification,
      listener: (context, state) {
        if (state.user != null) {
          // Update SessionBloc with the logged-in user so avatar appears immediately
          context.read<SessionBloc>().add(SessionUserUpdated(state.user!));
          context.go(AppRoutes.home);
        }
        if (state.errorMessage != null) {
          context.showTypedSnackBar(state.errorMessage!,
              type: SnackBarType.error);
        }
        if (state.requiresVerification && state.verificationEmail != null) {
          context.push(
            AppRoutes.otpVerification,
            extra: {
              'email': state.verificationEmail,
              'verificationType': VerificationType.login,
            },
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LoginHeader(),
                25.verticalSpace,
                LoginForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  onEmailChanged: _onEmailChanged,
                  onPasswordChanged: _onPasswordChanged,
                  onTogglePasswordVisibility: _onTogglePasswordVisibility,
                  onLogin: _onLogin,
                  onForgotPassword: _onForgotPassword,
                ),
                15.verticalSpace,
                CreateAccountLink(onCreateAccount: _onCreateAccount),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
