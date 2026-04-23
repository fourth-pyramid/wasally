import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/injection/injection.dart';
import 'package:wassaly/features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:wassaly/features/auth/presentation/widgets/forgot_password/back_to_login_link.dart';
import 'package:wassaly/features/auth/presentation/widgets/forgot_password/forgot_password_form.dart';
import 'package:wassaly/features/auth/presentation/widgets/forgot_password/forgot_password_header.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ForgotPasswordBloc>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    context.read<ForgotPasswordBloc>().add(EmailChanged(value));
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ForgotPasswordBloc>().add(const SendOtpSubmitted());
    }
  }

  void _onBackToLogin() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listenWhen: (previous, current) =>
          previous.isSuccess != current.isSuccess ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.isSuccess) {
          context.showSuccessSnackBar('auth.reset_link_sent'.tr());
          context.push(
            AppRoutes.otpVerification,
            extra: {
              'email': state.email,
              'verificationType': VerificationType.forgotPassword,
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
                const ForgotPasswordHeader(),
                ForgotPasswordForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  onEmailChanged: _onEmailChanged,
                  onSubmit: _onSubmit,
                ),
                SizedBox(height: 40.h),
                BackToLoginLink(onPressed: _onBackToLogin),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
