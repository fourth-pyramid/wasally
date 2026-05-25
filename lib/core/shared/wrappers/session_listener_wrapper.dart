import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/profile/presentation/bloc/profile/profile_bloc.dart';

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
          // Load data for the new user
          context.read<ProfileBloc>().add(const ProfileFetched());
          context.read<CartBloc>().add(const LoadCartItemsEvent());
          context.read<FavoriteBloc>().add(const GetFavoritesEvent());
          context.read<FavoriteBloc>().add(const GetServiceFavoritesEvent());
          appRouter.go(AppRoutes.home);
        } else if (state is SessionUnauthenticated) {
          // Clear data when user logs out
          context.read<ProfileBloc>().add(const ProfileReset());
          context.read<CartBloc>().add(const ClearCartEvent());
          context.read<FavoriteBloc>().add(const ClearFavoritesEvent());
          // Dismiss any active snackbar before navigating so nothing leaks
          // onto the login screen after account deletion or logout.
          ScaffoldMessenger.of(context).clearSnackBars();
          appRouter.go(AppRoutes.login);
        }
      },
      child: child,
    );
  }
}
