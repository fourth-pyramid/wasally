import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';

class AuthCallbackPage extends StatefulWidget {
  final String? token;
  final String? id;
  final String? fullName;
  final String? email;
  final String? avatar;

  const AuthCallbackPage({
    super.key,
    this.token,
    this.id,
    this.fullName,
    this.email,
    this.avatar,
  });

  @override
  State<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  final GoogleLoginUseCase _googleLoginUseCase = sl<GoogleLoginUseCase>();

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure the widget tree is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_handleAuthCallback());
    });
  }

  Future<void> _handleAuthCallback() async {
    final token = widget.token;
    final id = widget.id;
    final email = widget.email;

    if (token == null || token.isEmpty || id == null || email == null) {
      if (mounted) {
        context
          ..showTypedSnackBar(
            context.l10n.auth_login_failed,
            type: SnackBarType.error,
          )
          ..go(AppRoutes.login);
      }
      return;
    }

    final result = await _googleLoginUseCase.completeGoogleLogin(
      token: token,
      id: id,
      fullName: widget.fullName ?? '',
      email: email,
      avatar: widget.avatar,
    );

    if (mounted) {
      result.fold(
        (failure) {
          context
            ..showTypedSnackBar(
              context.l10n.auth_login_failed,
              type: SnackBarType.error,
            )
            ..go(AppRoutes.login);
        },
        (user) {
          // Notify SessionBloc about the logged-in user so avatar appears immediately
          sl<SessionBloc>().add(SessionUserUpdated(user));

          context
            ..showTypedSnackBar(context.l10n.auth_login_success)
            ..go(AppRoutes.home);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: AppLoading(message: context.l10n.auth_logging_in),
      );
}
