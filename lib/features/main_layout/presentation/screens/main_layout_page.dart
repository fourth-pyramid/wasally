import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_event.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_state.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:wassaly/features/main_layout/presentation/widgets/exit_confirm_overlay.dart';
import 'package:wassaly/features/main_layout/presentation/widgets/nav_bar.dart';

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
  DateTime? _lastBackPressTime;
  OverlayEntry? _exitOverlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserDataIfNeeded();
    });
  }

  @override
  void dispose() {
    // Cancel any pending overlay to avoid inserting into a detached overlay.
    _exitOverlayEntry?.remove();
    _exitOverlayEntry = null;
    super.dispose();
  }

  /// Loads cart and favorites only when the user is authenticated AND each
  /// slice has never been fetched (status == initial). Covers the cold-start
  /// case; hot-auth transitions are handled by the BlocListener below.
  void _loadUserDataIfNeeded() {
    if (!mounted) return;
    final sessionState = context.read<SessionBloc>().state;
    if (sessionState is! SessionAuthenticated) return;

    final cartState = context.read<CartBloc>().state;
    if (cartState.status == CartStatus.initial) {
      context.read<CartBloc>().add(const LoadCartItemsEvent());
    }

    final favoriteState = context.read<FavoriteBloc>().state;
    if (favoriteState.status == FavoriteStatus.initial) {
      context.read<FavoriteBloc>().add(const GetFavoritesEvent());
      context.read<FavoriteBloc>().add(const GetServiceFavoritesEvent());
    }
  }

  void _onTap(int index) {
    // Re-tapping the Home tab scrolls to top / refreshes.
    if (index == 0 && widget.navigationShell.currentIndex == 0) {
      unawaited(sl<HomeNavigationService>().scrollToTopOrRefresh());
      return;
    }
    widget.navigationShell.goBranch(
      index,
      // Reset to the branch's initial location only when re-tapping the
      // *currently active* tab (so back-stack is cleared on double-tap).
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _handleBackPress() {
    // 1. Sub-route / dialog stacked — pop it.
    if (context.canPop()) {
      context.pop();
      return;
    }

    // 2. Not on Home tab — navigate home.
    if (widget.navigationShell.currentIndex != 0) {
      _onTap(0);
      return;
    }

    // 3. On Home tab — double-back to exit.
    final now = DateTime.now();
    final elapsed = _lastBackPressTime == null
        ? const Duration(days: 1)
        : now.difference(_lastBackPressTime!);

    if (elapsed > const Duration(seconds: 2)) {
      _lastBackPressTime = now;
      _showExitOverlay();
    } else {
      _exitOverlayEntry?.remove();
      _exitOverlayEntry = null;
      unawaited(SystemNavigator.pop());
    }
  }

  void _showExitOverlay() {
    _exitOverlayEntry?.remove();

    const overlayDuration = Duration(seconds: 2);
    const fadeDuration = Duration(milliseconds: 250);

    _exitOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.sizeOf(context).height * 0.45,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: ExitConfirmOverlay(
            message: context.l10n.app_exit_confirm,
            duration: overlayDuration,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_exitOverlayEntry!);

    // Auto-remove after the overlay has finished its fade-out animation.
    unawaited(
      Future.delayed(overlayDuration + fadeDuration, () {
        _exitOverlayEntry?.remove();
        _exitOverlayEntry = null;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return MultiBlocListener(
      listeners: [
        BlocListener<SessionBloc, SessionState>(
          // Trigger only on the transition to authenticated, not on every rebuild.
          listenWhen: (prev, curr) =>
              prev is! SessionAuthenticated && curr is SessionAuthenticated,
          listener: (context, _) {
            final cartBloc = context.read<CartBloc>();
            final favoriteBloc = context.read<FavoriteBloc>();

            cartBloc.add(const LoadCartItemsEvent());
            favoriteBloc
              ..add(const GetFavoritesEvent())
              ..add(const GetServiceFavoritesEvent());
          },
        ),
      ],
      child: PopScope<Object?>(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _handleBackPress();
        },
        child: Scaffold(
          body: widget.navigationShell,
          bottomNavigationBar: AppShowcase(
            // ponytail: Global key to reference the main layout navigation bar in the home tour
            showcaseKey: AppShowcaseKeys.homeNavBar,
            title: context.l10n.showcase_home_nav_title,
            description: context.l10n.showcase_home_nav_desc,
            isLast: true,
            child: MainNavBar(
              currentIndex: widget.navigationShell.currentIndex,
              onTap: _onTap,
              backgroundColor: cs.surface,
              selectedItemColor: cs.primary,
              unselectedItemColor: cs.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
