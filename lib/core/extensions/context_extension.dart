import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/shared/enums/snack_bar_type.dart';
import 'package:wassaly/core/theme/color_schemes.dart';
import 'package:wassaly/l10n/app_localizations.dart';

extension ContextExtension on BuildContext {
  S get l10n => S.of(this)!;
  // ── Theme shortcuts ──────────────────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  TextTheme get typography => theme.textTheme;
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Semantic/custom colors (success, warning, info).
  AppColorsExtension get appColors =>
      theme.extension<AppColorsExtension>() ??
      (isDarkMode ? AppPalettes.dark : AppPalettes.light);

  // ── MediaQuery shortcuts ─────────────────────────────────────────────────
  Size get mediaQuerySize => MediaQuery.sizeOf(this);
  Size get screenSize => mediaQuerySize;
  double get width => mediaQuerySize.width;
  double get height => mediaQuerySize.height;
  double get bottomPadding => MediaQuery.paddingOf(this).bottom;

  // ── Breakpoints ──────────────────────────────────────────────────────────
  static const double kMobileBreakpoint = 600.0;
  static const double kTabletBreakpoint = 1024.0;

  bool get isMobile => width < kMobileBreakpoint;
  bool get isTablet => width >= kMobileBreakpoint && width < kTabletBreakpoint;
  bool get isDesktop => width >= kTabletBreakpoint;

  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  // ── Sizing shortcuts (ScreenUtil) ────────────────────────────────────────
  double w(num value) => value.w;
  double h(num value) => value.h;
  double sp(num value) => value.sp;
  double r(num value) => value.r;

  Widget vS(num value) => value.verticalSpace;
  Widget hS(num value) => value.horizontalSpace;

  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';

  // ── Keyboard ──────────────────────────────────────────────────────────────
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;
  void hideKeyboard() => FocusScope.of(this).unfocus();

  // ── Platform ─────────────────────────────────────────────────────────────
  bool get isIOS => theme.platform == TargetPlatform.iOS;
  bool get isAndroid => theme.platform == TargetPlatform.android;

  Future<T?> showAppBottomSheet<T>({
    required WidgetBuilder builder,
    bool isScrollControlled = true,
    bool useSafeArea = true,
  }) {
    if (isIOS) {
      return showCupertinoModalPopup<T>(
        context: this,
        useRootNavigator: false,
        builder: builder,
      );
    }
    return showModalBottomSheet<T>(
      context: this,
      builder: builder,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
    );
  }

  Future<T?> showAppDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    if (isIOS) {
      return showCupertinoDialog<T>(
        context: this,
        barrierDismissible: barrierDismissible,
        builder: builder,
      );
    }
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  void showTypedSnackBar(
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final bg = switch (type) {
      SnackBarType.success => appColors.success,
      SnackBarType.warning => appColors.warning,
      SnackBarType.error => colors.error,
      SnackBarType.info => colors.inverseSurface,
    };
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: bg,
          duration: duration,
        ),
      );
  }

  // ── Routing shortcuts ────────────────────────────────────────────────────
  String get currentRoute {
    final router = GoRouter.of(this);
    final lastMatch = router.routerDelegate.currentConfiguration.last;
    final matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
