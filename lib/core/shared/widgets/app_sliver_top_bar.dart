import 'package:wassaly/core/imports/imports.dart';

class AppSliverTopBar extends StatelessWidget {
  const AppSliverTopBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.onPressed,
    this.isTransparent = false,
    this.showLogo = false,
    this.pinned = false,
    this.floating = true,
    this.snap = true,
    this.bottom,
    this.automaticallyImplyLeading = true,
  });

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final VoidCallback? onPressed;
  final bool centerTitle;
  final bool isTransparent;
  final bool showLogo;
  final bool pinned;
  final bool floating;
  final bool snap;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading;

  // FIX 1: ثابتة — مش بتتغير بين builds
  static const _shellRoutes = {
    AppRoutes.home,
    AppRoutes.cart,
    AppRoutes.favorite,
    AppRoutes.profile,
  };

  String? _currentPath(BuildContext context) {
    try {
      return GoRouterState.of(context).uri.path;
    } catch (_) {
      try {
        return GoRouter.of(context).routeInformationProvider.value.uri.path;
      } catch (_) {
        return null;
      }
    }
  }

  void _handleBack(BuildContext context) {
    if (onPressed != null) {
      onPressed!();
      return;
    }
    try {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.home);
      }
    } catch (_) {
      if (context.mounted) {
        context.go(AppRoutes.home);
      }
    }
  }

  // FIX 2: extracted كـ method عشان مش تتبني لو مش محتاجاها
  Widget _buildTitle(BuildContext context, ColorScheme cs, TextTheme tt) {
    if (titleWidget != null) return titleWidget!;

    final List<Widget> children = [];

    if (showLogo) {
      children.add(
        const CommonImage(
          imageUrl: AppAssets.logo,
          height: 45,
          memCacheHeight: 45 * 2,
          fit: BoxFit.cover,
        ),
      );
    }

    if (title != null && title!.isNotEmpty) {
      if (showLogo) children.add(8.horizontalSpace);
      children.add(
        Flexible(
          child: Text(
            title!,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    if (children.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          centerTitle ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final isIOS = context.isIOS;

    final currentPath = _currentPath(context);
    // FIX 3: Set lookup بدل 4 مقارنات
    final isShellRoute =
        currentPath != null && _shellRoutes.contains(currentPath);
    final canPop =
        automaticallyImplyLeading && (context.canPop() || !isShellRoute);

    final titleWidget = _buildTitle(context, cs, tt);

    if (isIOS) {
      return SliverSafeArea(
        bottom: false,
        sliver: SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoNavigationBar(
                middle: titleWidget,
                backgroundColor:
                    isTransparent ? Colors.transparent : cs.surface,
                border: bottom != null
                    ? null
                    : (isTransparent ? null : const Border()),
                leading: leading ??
                    (canPop
                        ? CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => _handleBack(context),
                            child: Icon(
                              CupertinoIcons.back,
                              color: cs.primary,
                            ),
                          )
                        : null),
                trailing: actions != null && actions!.isNotEmpty
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions!,
                      )
                    : null,
              ),
              if (bottom != null) bottom!,
            ],
          ),
        ),
      );
    }

    return SliverAppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      pinned: pinned,
      floating: floating,
      snap: snap,
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: isTransparent ? Colors.transparent : cs.surface,
      shadowColor: Colors.transparent,
      foregroundColor: cs.primary,
      title: titleWidget,
      leadingWidth: leading != null ? 56.w : (canPop ? 40.w : null),
      leading: leading ??
          (canPop
              ? GestureDetector(
                  onTap: () => _handleBack(context),
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: Icon(
                      Icons.arrow_back,
                      color: cs.primary,
                    ),
                  ),
                )
              : null),
      actions: actions ?? const [], // FIX 4: const بدل [] جديدة في كل build
      bottom: bottom,
    );
  }
}
