import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/injection/injection.dart';
import 'package:wassaly/features/auth/presentation/bloc/login_bloc.dart';
import 'package:wassaly/features/auth/presentation/widgets/create_account_link.dart';
import 'package:wassaly/features/auth/presentation/widgets/login_form.dart';
import 'package:wassaly/features/auth/presentation/widgets/login_header.dart';

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

  void _onLoginWithGoogle() {
    context.read<LoginBloc>().add(const LoginWithGoogle());
  }

  void _onLoginWithFacebook() {
    context.read<LoginBloc>().add(const LoginWithFacebook());
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
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.user != null) {
          context.go(AppRoutes.home);
        }
        if (state.errorMessage != null) {
          context.showErrorSnackBar(state.errorMessage!);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LoginHeader(),
                SizedBox(height: 25.h),
                LoginForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  onEmailChanged: _onEmailChanged,
                  onPasswordChanged: _onPasswordChanged,
                  onTogglePasswordVisibility: _onTogglePasswordVisibility,
                  onLogin: _onLogin,
                  onForgotPassword: _onForgotPassword,
                  onLoginWithGoogle: _onLoginWithGoogle,
                  onLoginWithFacebook: _onLoginWithFacebook,
                ),
                SizedBox(height: 15.h),
                CreateAccountLink(onCreateAccount: _onCreateAccount),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
