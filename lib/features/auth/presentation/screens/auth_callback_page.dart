import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/core/injection/injection.dart';
import 'package:wassaly/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:wassaly/features/auth/data/models/user_model.dart';
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
  final AuthLocalDataSource _localDataSource = sl<AuthLocalDataSource>();

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure the widget tree is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleAuthCallback();
    });
  }

  Future<void> _handleAuthCallback() async {
    final token = widget.token;
    final id = widget.id;
    final email = widget.email;

    if (token == null || token.isEmpty || id == null || email == null) {
      if (mounted) {
        context.showErrorSnackBar('auth.login_failed'.tr());
        context.go(AppRoutes.login);
      }
      return;
    }

    try {
      // Save token
      await _localDataSource.saveToken(token);

      // Create and cache user
      final user = UserModel(
        id: id,
        email: email,
        name: widget.fullName,
        phone: null,
        avatarUrl: widget.avatar,
        token: token,
      );
      await _localDataSource.cacheUser(user);

      if (mounted) {
        // Notify SessionBloc about the logged-in user so avatar appears immediately
        sl<SessionBloc>().add(SessionUserUpdated(user));

        context.showSuccessSnackBar('auth.login_success'.tr());
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('auth.login_failed'.tr());
        context.go(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: cs.primary,
            ),
            20.verticalSpace,
            Text(
              'auth.logging_in'.tr(),
              style: context.theme.textTheme.bodyLarge?.copyWith(
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
