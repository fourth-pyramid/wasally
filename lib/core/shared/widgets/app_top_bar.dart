import 'package:wassaly/core/imports/imports.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.centerTitle = true,
    this.onPressed,
    this.isTransparent = false,
    this.showLogo = false,
    this.bottom,
  });

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final VoidCallback? onPressed;
  final bool centerTitle;
  final bool isTransparent;
  final bool showLogo;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isIOS = context.isIOS;
    final canPop = context.canPop();
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    void handleBack() {
      if (onPressed != null) {
        onPressed!();
      } else if (canPop) {
        context.pop();
      } else {
        context.go(AppRoutes.home);
      }
    }

    Widget buildTitle() {
      if (titleWidget != null) return titleWidget!;

      final List<Widget> children = [];

      if (showLogo) {
        children.add(
          Image.asset(
            AppAssets.logo,
            height: 32.h,
            fit: BoxFit.contain,
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
        mainAxisAlignment: centerTitle ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: children,
      );
    }

    if (isIOS) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoNavigationBar(
            middle: buildTitle(),
            backgroundColor: isTransparent ? Colors.transparent : cs.surface,
            border: bottom != null ? null : (isTransparent ? null : const Border()),
            leading: canPop
                ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: handleBack,
                    child: Icon(
                      CupertinoIcons.back,
                      color: cs.primary,
                    ),
                  )
                : const SizedBox.shrink(),
            trailing: actions != null && actions!.isNotEmpty
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!,
                  )
                : null,
          ),
          if (bottom != null) bottom!,
        ],
      );
    }

    return AppBar(
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: isTransparent ? Colors.transparent : cs.surface,
      shadowColor: Colors.transparent,
      title: buildTitle(),
      leadingWidth: canPop ? 40.w : null,
      leading: canPop
          ? GestureDetector(
              onTap: handleBack,
              child: ColoredBox(
                color: Colors.transparent,
                child: Icon(
                  Icons.arrow_back,
                  color: cs.primary,
                ),
              ),
            )
          : null,
      iconTheme: theme.appBarTheme.iconTheme?.copyWith(color: cs.primary),
      actions: actions ?? [],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      (PlatformInfo.isIOS ? 44.0 : kToolbarHeight) +
          (bottom?.preferredSize.height ?? 0.0));
}
