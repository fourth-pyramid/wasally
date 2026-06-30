import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/google_login/google_login_bloc.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';

class AuthCallbackPage extends StatelessWidget {
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
  Widget build(BuildContext context) => BlocProvider(
        create: (context) {
          final bloc = sl<GoogleLoginBloc>();
          if (token != null &&
              token!.isNotEmpty &&
              id != null &&
              email != null) {
            bloc.add(
              GoogleLoginCallbackReceived(
                GoogleLoginCallbackData(
                  token: token!,
                  id: id!,
                  fullName: fullName ?? '',
                  email: email!,
                  status: 'success',
                  avatar: avatar,
                ),
              ),
            );
          }
          return bloc;
        },
        child: BlocListener<GoogleLoginBloc, GoogleLoginState>(
          listener: (context, state) {
            if (state.user != null) {
              context.read<SessionBloc>().add(SessionUserUpdated(state.user!));
              context
                ..showTypedSnackBar(context.l10n.auth_login_success)
                ..go(AppRoutes.home);
            } else if (state.errorMessage != null) {
              context
                ..showTypedSnackBar(
                  state.errorMessage ?? context.l10n.auth_login_failed,
                  type: SnackBarType.error,
                )
                ..go(AppRoutes.login);
            }
          },
          child: Scaffold(
            body: Builder(
              builder: (context) {
                if (token == null ||
                    token!.isEmpty ||
                    id == null ||
                    email == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context
                      ..showTypedSnackBar(
                        context.l10n.auth_login_failed,
                        type: SnackBarType.error,
                      )
                      ..go(AppRoutes.login);
                  });
                }
                return AppLoading(message: context.l10n.auth_logging_in);
              },
            ),
          ),
        ),
      );
}
