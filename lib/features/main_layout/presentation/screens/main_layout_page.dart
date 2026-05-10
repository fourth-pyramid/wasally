import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_event.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_state.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';

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
    final sessionState = context.read<SessionBloc>().state;
    debugPrint(
        '[MainLayout] initState - Session state: ${sessionState.runtimeType}');

    if (sessionState is SessionAuthenticated) {
      debugPrint(
          '[MainLayout] User is authenticated, loading cart and favorites');
      // Load cart items
      context.read<CartBloc>().add(const LoadCartItemsEvent());
      // Load favorite items
      context.read<FavoriteBloc>().add(const GetFavoritesEvent());
    } else {
      debugPrint('[MainLayout] User is not authenticated');
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
    final tt = context.textTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<CartBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<FavoriteBloc>(),
        ),
      ],
      child: MultiBlocListener(
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
          // Also load data if already authenticated on page load
          BlocListener<SessionBloc, SessionState>(
            listenWhen: (prev, curr) => curr is SessionAuthenticated,
            listener: (context, state) {
              debugPrint(
                  '[MainLayout] User is authenticated, checking if data needs loading');
              // Check if cart is empty, if so load it
              final cartState = context.read<CartBloc>().state;
              if (cartState.items.isEmpty) {
                debugPrint('[MainLayout] Cart is empty, loading cart items');
                context.read<CartBloc>().add(const LoadCartItemsEvent());
              }

              // Check if favorites are empty, if so load them
              final favoriteState = context.read<FavoriteBloc>().state;
              if (favoriteState.favorites.data.isEmpty) {
                debugPrint(
                    '[MainLayout] Favorites are empty, loading favorites');
                context.read<FavoriteBloc>().add(const GetFavoritesEvent());
              }
            },
          ),
        ],
        child: Scaffold(
          body: widget.navigationShell,
          bottomNavigationBar: BlocBuilder<SessionBloc, SessionState>(
            buildWhen: (prev, curr) {
              // Rebuild when state type changes (e.g., SessionLoading -> SessionAuthenticated)
              if (prev.runtimeType != curr.runtimeType) return true;
              // Rebuild when avatar URL changes
              final prevAvatar =
                  prev is SessionAuthenticated ? prev.user.avatarUrl : null;
              final currAvatar =
                  curr is SessionAuthenticated ? curr.user.avatarUrl : null;
              return prevAvatar != currAvatar;
            },
            builder: (context, state) {
              final avatarUrl =
                  state is SessionAuthenticated ? state.user.avatarUrl : null;

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
                    label: 'nav.nav_home'.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: BlocBuilder<CartBloc, CartState>(
                      buildWhen: (prev, curr) =>
                          prev.cartCount != curr.cartCount,
                      builder: (context, state) => Badge(
                        label: state.cartCount > 0
                            ? Text(
                                state.cartCount.toString(),
                                style: tt.labelSmall?.copyWith(
                                  color: context.colors.onError,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                        isLabelVisible: state.cartCount > 0,
                        child: const Icon(Icons.shopping_cart_outlined),
                      ),
                    ),
                    activeIcon: BlocBuilder<CartBloc, CartState>(
                      buildWhen: (prev, curr) =>
                          prev.cartCount != curr.cartCount,
                      builder: (context, state) => Badge(
                        label: state.cartCount > 0
                            ? Text(
                                state.cartCount.toString(),
                                style: tt.labelSmall?.copyWith(
                                  color: context.colors.onError,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                        isLabelVisible: state.cartCount > 0,
                        child: const Icon(Icons.shopping_cart_rounded),
                      ),
                    ),
                    label: 'nav.nav_cart'.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.favorite_outline),
                    activeIcon: const Icon(Icons.favorite_rounded),
                    label: 'nav.nav_favorite'.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: avatarUrl != null && avatarUrl.isNotEmpty
                        ? CommonImage(
                            width: 26,
                            height: 22,
                            memCacheHeight: 22 * 3,
                            imageUrl: avatarUrl,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(16.r),
                          )
                        : const Icon(Icons.person_outline),
                    activeIcon: avatarUrl != null && avatarUrl.isNotEmpty
                        ? CommonImage(
                            width: 26,
                            height: 22,
                            memCacheHeight: 22 * 3,
                            imageUrl: avatarUrl,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(16.r),
                          )
                        : const Icon(Icons.person_rounded),
                    label: 'nav.nav_profile'.tr(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
