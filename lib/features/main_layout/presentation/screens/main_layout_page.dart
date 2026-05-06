import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';

class MainLayoutPage extends StatelessWidget {
  const MainLayoutPage({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      body: navigationShell,
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
            currentIndex: navigationShell.currentIndex.clamp(0, 3),
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
                icon: Badge(
                  label: Text(
                    '2',
                    style: tt.labelSmall?.copyWith(
                      color: context.colors.onError,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                activeIcon: Badge(
                  label: Text(
                    '2',
                    style: tt.labelSmall?.copyWith(
                      color: context.colors.onError,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Icon(Icons.shopping_cart_rounded),
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
    );
  }
}
