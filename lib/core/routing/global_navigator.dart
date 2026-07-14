import 'package:flutter/material.dart';

// ponytail: Kept global keys/context accessors but removed the unused GlobalNavigator class.

/// Global [NavigatorState] key used by the app's root [Navigator].
///
/// This is wired into `MaterialApp.navigatorKey` in `app.dart` so that
/// navigation and overlays (e.g. toasts) can be triggered without a
/// local [BuildContext] reference.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Convenient accessor for the current root [BuildContext].
///
/// Returns `null` before the app is mounted. Check for `null` before
/// using this in background services or repositories.
BuildContext? get rootContext => rootNavigatorKey.currentContext;
