import 'package:wassaly/core/imports/imports.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.titleWidget,
    this.actions,
    this.centerTitle = true,
    this.onPressed,
    this.isTransparent = false,
  });

  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final VoidCallback? onPressed;
  final bool? centerTitle;
  final bool isTransparent;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isIOS = context.isIOS;

    final bool canPop = context.canPop();

    void handleBack() {
      if (onPressed != null) {
        onPressed!();
      } else if (canPop) {
        context.pop();
      } else {
        context.go(AppRoutes.home);
      }
    }

    if (isIOS) {
      return CupertinoNavigationBar(
        middle: titleWidget ??
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
        backgroundColor: isTransparent ? Colors.transparent : null,
        border: isTransparent ? null : const Border(),
        leading: canPop
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: handleBack,
                child: Icon(
                  CupertinoIcons.back,
                  color: theme.colorScheme.primary,
                ),
              )
            : null,
        trailing: actions != null && actions!.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              )
            : null,
      );
    }

    return AppBar(
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: isTransparent ? Colors.transparent : null,
      shadowColor: Colors.transparent,
      title: titleWidget ??
          Text(
            title,
            style: theme.appBarTheme.titleTextStyle?.copyWith(
                  fontWeight: FontWeight.w600,
                ) ??
                theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
      leadingWidth: 40.w,
      leading: GestureDetector(
        onTap: handleBack,
        child: ColoredBox(
          color: Colors.transparent,
          child: Icon(
            Icons.arrow_back,
            color: theme.appBarTheme.iconTheme?.color ??
                theme.colorScheme.onSurface,
          ),
        ),
      ),
      iconTheme: theme.appBarTheme.iconTheme,
      actions: actions ?? [],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(PlatformInfo.isIOS ? 44 : kToolbarHeight);
}
