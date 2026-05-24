import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_state.dart';

/// Bottom navigation bar for the main layout.
/// Extracted into its own widget so it owns its own [BlocSelector] for
/// [avatarUrl] — the outer Scaffold no longer rebuilds when the avatar changes.
class MainNavBar extends StatelessWidget {
  const MainNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.backgroundColor,
    required this.selectedItemColor,
    required this.unselectedItemColor,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionBloc, SessionState, String?>(
      selector: (state) =>
          state is SessionAuthenticated ? state.user.avatarUrl : null,
      builder: (context, avatarUrl) {
        return BottomNavigationBar(
          currentIndex: currentIndex.clamp(0, 3),
          onTap: onTap,
          backgroundColor: backgroundColor,
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded),
              label: context.l10n.nav_nav_home,
            ),
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
            BottomNavigationBarItem(
              icon: _ProfileNavIcon(avatarUrl: avatarUrl, isActive: false),
              activeIcon: _ProfileNavIcon(avatarUrl: avatarUrl, isActive: true),
              label: context.l10n.nav_nav_profile,
            ),
          ],
        );
      },
    );
  }
}

/// Cart icon with a badge — has its own tight [BlocSelector] on [cartCount]
/// so only the badge rebuilds, not the navigation bar.
class _CartBadgeIcon extends StatelessWidget {
  const _CartBadgeIcon({
    required this.isActive,
    required this.baseIcon,
  });

  final bool isActive;
  final IconData baseIcon;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartBloc, CartState, int>(
      selector: (state) => state.cartCount,
      builder: (context, cartCount) => Badge(
        label: cartCount > 0
            ? Text(
                cartCount.toString(),
                style: context.textTheme.labelSmall?.copyWith(
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

/// Profile icon — shows the user's avatar when available, falls back to a
/// person icon. Receives [avatarUrl] from the parent [MainNavBar] selector so
/// no additional bloc subscription is created here.
class _ProfileNavIcon extends StatelessWidget {
  const _ProfileNavIcon({
    required this.avatarUrl,
    required this.isActive,
  });

  final String? avatarUrl;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    // Bounding size is completely fixed (32.r x 32.r) to keep the navigation bar
    // height stable, while the inside image/icon scales smoothly when active.
    final double targetSize = isActive ? 30 : 27;

    return SizedBox(
      width: 32.w,
      height: 32.h,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: targetSize.r,
          height: targetSize.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isActive
                ? Border.all(
                    color: context.colors.primary,
                    width: 1.5.w,
                  )
                : Border.all(
                    color: context.colors.outlineVariant,
                    width: 1.w,
                  ),
          ),
          child: ClipOval(
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? CommonImage(
                    width: targetSize,
                    height: targetSize,
                    imageUrl: avatarUrl!,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Icon(
                      isActive ? Icons.person_rounded : Icons.person_outline,
                      size: (targetSize * 0.75).r,
                      color: isActive
                          ? context.colors.primary
                          : context.colors.onSurfaceVariant,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
