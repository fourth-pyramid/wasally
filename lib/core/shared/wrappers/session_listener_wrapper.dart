import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';

class SessionListenerWrapper extends StatelessWidget {
  final Widget child;
  const SessionListenerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listener: (context, state) {
        // Skip navigation on splash page - let splash handle its own navigation
        if (appRouter.routeInformationProvider.value.uri.path ==
            AppRoutes.splash) {
          return;
        }
        if (state is SessionAuthenticated) {
          appRouter.go(AppRoutes.home);
        } else if (state is SessionUnauthenticated) {
          appRouter.go(AppRoutes.login);
        }
      },
      child: child,
    );
  }
}
