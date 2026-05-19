import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_event.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_state.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';

class MainLayoutPage extends StatefulWidget {
  const MainLayoutPage({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  @override
  void initState() {
    super.initState();
    // Load data after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserDataIfNeeded();
    });
  }

  void _loadUserDataIfNeeded() {
    if (!mounted) return;
    final sessionState = context.read<SessionBloc>().state;

    if (sessionState is SessionAuthenticated) {
      // Only load if never fetched before (status == initial).
      // This prevents double-loading when the data was fetched but empty.
      final cartState = context.read<CartBloc>().state;
      if (cartState.status == CartStatus.initial) {
        debugPrint('[MainLayout] Cart not yet loaded, loading cart items');
        context.read<CartBloc>().add(const LoadCartItemsEvent());
      }

      final favoriteState = context.read<FavoriteBloc>().state;
      if (favoriteState.status == FavoriteStatus.initial) {
        debugPrint('[MainLayout] Favorites not yet loaded, loading favorites');
        context.read<FavoriteBloc>().add(const GetFavoritesEvent());
      }
    }
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return MultiBlocListener(
      listeners: [
        // Listen to SessionBloc changes and load cart/favorites when authenticated
        BlocListener<SessionBloc, SessionState>(
          listenWhen: (prev, curr) =>
              prev is! SessionAuthenticated && curr is SessionAuthenticated,
          listener: (context, state) {
            debugPrint(
                '[MainLayout] User authenticated, loading cart and favorites');
            // Load cart items when user becomes authenticated
            context.read<CartBloc>().add(const LoadCartItemsEvent());
            // Load favorite items when user becomes authenticated
            context.read<FavoriteBloc>().add(const GetFavoritesEvent());
          },
        ),
      ],
      child: Scaffold(
        body: widget.navigationShell,
        // FIX 4: BlocSelector now only selects avatarUrl (single field),
        // so the BottomNavigationBar only rebuilds when avatar changes.
        // FIX 5: Extracted _CartBadgeIcon and _ProfileNavIcon as private
        // widgets — cart badge rebuilds independently via its own BlocSelector,
        // not the entire nav bar.
        bottomNavigationBar: BlocSelector<SessionBloc, SessionState, String?>(
          selector: (state) =>
              state is SessionAuthenticated ? state.user.avatarUrl : null,
          builder: (context, avatarUrl) {
            return BottomNavigationBar(
              currentIndex: widget.navigationShell.currentIndex.clamp(0, 3),
              onTap: _onTap,
              backgroundColor: cs.surface,
              selectedItemColor: cs.primary,
              unselectedItemColor: cs.onSurfaceVariant,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home_rounded),
                  label: context.l10n.nav_nav_home,
                ),
                // FIX 5: _CartBadgeIcon — BlocSelector scoped to cartCount only,
                // rebuilds independently without triggering full nav bar rebuild
                BottomNavigationBarItem(
                  icon: const _CartBadgeIcon(
                    isActive: false,
                    baseIcon: Icons.shopping_cart_outlined,
                  ),
                  activeIcon: const _CartBadgeIcon(
                    isActive: true,
                    baseIcon: Icons.shopping_cart_rounded,
                  ),
                  label: context.l10n.nav_nav_cart,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite_outline),
                  activeIcon: const Icon(Icons.favorite_rounded),
                  label: context.l10n.nav_nav_favorite,
                ),
                // FIX 5: _ProfileNavIcon — stable widget, only rebuilds when
                // avatarUrl changes (already passed from outer BlocSelector)
                BottomNavigationBarItem(
                  icon: _ProfileNavIcon(
                    avatarUrl: avatarUrl,
                    isActive: false,
                  ),
                  activeIcon: _ProfileNavIcon(
                    avatarUrl: avatarUrl,
                    isActive: true,
                  ),
                  label: context.l10n.nav_nav_profile,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// FIX 5: Extracted private widget — has its own tight BlocSelector for
/// cartCount so only the badge rebuilds, not the entire BottomNavigationBar.
class _CartBadgeIcon extends StatelessWidget {
  const _CartBadgeIcon({
    required this.isActive,
    required this.baseIcon,
  });

  final bool isActive;
  final IconData baseIcon;

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;
    return BlocSelector<CartBloc, CartState, int>(
      selector: (state) => state.cartCount,
      builder: (context, cartCount) => Badge(
        label: cartCount > 0
            ? Text(
                cartCount.toString(),
                style: tt.labelSmall?.copyWith(
                  color: context.colors.onError,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
        isLabelVisible: cartCount > 0,
        child: Icon(baseIcon),
      ),
    );
  }
}

/// FIX 5: Extracted private widget — receives avatarUrl from the outer
/// BlocSelector so no extra subscriptions are created here.
class _ProfileNavIcon extends StatelessWidget {
  const _ProfileNavIcon({
    required this.avatarUrl,
    required this.isActive,
  });

  final String? avatarUrl;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CommonImage(
        width: 26,
        height: 22,
        memCacheHeight: 22 * 3,
        imageUrl: avatarUrl!,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(16.r),
      );
    }
    return Icon(isActive ? Icons.person_rounded : Icons.person_outline);
  }
}
