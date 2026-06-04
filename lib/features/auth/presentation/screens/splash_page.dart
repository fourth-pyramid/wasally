import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/core/services/notification_service.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => const _SplashView();
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _logoSlide;
  late final Animation<double> _contentFade;
  late final Animation<double> _contentSlide;

  final Completer<void> _initCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    unawaited(_initializeServices());

    _logoSlide = Tween<double>(begin: 0, end: -140.h).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.6, curve: Curves.easeInOutCubic),
      ),
    );

    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.85, curve: Curves.easeOut),
      ),
    );

    _contentSlide = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    unawaited(_startAnimation());
  }

  Future<void> _initializeServices() async {
    try {
      // Core services (Hive, Firebase, Storage, Env) are now initialized in main.dart
      // We only handle app-specific initialization here
      await AppConfig.init();
      _startDeferredServices();
    } on Exception catch (e) {
      debugPrint('Error checking user: $e');
    } finally {
      if (mounted && !_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    }
  }

  void _startDeferredServices() {
    unawaited(DeepLinkService.instance.initialize());
    unawaited(_initializeNotifications());
  }

  Future<void> _initializeNotifications() async {
    try {
      await NotificationService.instance.initialize();
      // Notifications loading is now handled by SessionListenerWrapper
      // to ensure authentication token is ready.
    } on Exception catch (e) {
      AppLogger.error('Notification init error: $e');
    }
  }

  Future<void> _startAnimation() async {
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;

    final animationFuture = _controller.forward();

    await Future.wait([
      animationFuture,
      _initCompleter.future,
    ]);

    if (mounted) {
      context.read<SessionBloc>().add(const SessionCheckRequested());
    }
  }

  void _handleNavigation(SessionState state) {
    if (!mounted) return;

    switch (state) {
      case SessionAuthenticated(user: final user):
        final userId = int.tryParse(user.id) ?? 0;
        if (userId > 0) {
          // Register current token AND setup refresh listener
          unawaited(FcmTokenService.instance.registerToken(userId));
          FcmTokenService.instance.setupTokenRefresh(userId);
        }
        context.go(AppRoutes.home);
      case SessionUnauthenticated() || SessionError():
        context.go(AppRoutes.login);
      default:
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (!_initCompleter.isCompleted) {
      _initCompleter.completeError(StateError('Disposed before init complete'));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.sizeOf(context).height;
    final topPadding = MediaQuery.paddingOf(context).top;

    final isDeviceDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    final bgColor = isDeviceDark ? Colors.black : Colors.white;
    final contentColor = isDeviceDark
        ? Colors.white.withValues(alpha: 0.9)
        : Colors.black.withValues(alpha: 0.9);

    return BlocListener<SessionBloc, SessionState>(
      listener: (context, state) {
        if (_controller.isCompleted) {
          _handleNavigation(state);
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        child: Container(
          width: 180.w,
          height: 180.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: const CommonImage(
              width: 180,
              height: 180,
              memCacheHeight: 180 * 2,
              fit: BoxFit.contain,
              imageUrl: 'assets/images/logo.png',
            ),
          ),
        ),
        builder: (context, logoWidget) {
          // نص الشاشة الحقيقي مع الأخذ في الاعتبار الـ status bar
          final centerY = (screenH - 180) / 2 - topPadding / 2;
          final logoY = centerY + _logoSlide.value;

          return Scaffold(
            backgroundColor: bgColor,
            body: Stack(
              children: [
                Positioned(
                  top: logoY,
                  left: 0,
                  right: 0,
                  child: Center(child: logoWidget),
                ),
                Positioned(
                  bottom: 110.h,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _contentFade,
                    child: Transform.translate(
                      offset: Offset(0, _contentSlide.value),
                      child: Text(
                        context.l10n.auth_splash_subtitle,
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color: contentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60.h,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _contentFade,
                    child: _PulsingDots(isDeviceDark: isDeviceDark),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PulsingDots extends StatefulWidget {
  const _PulsingDots({required this.isDeviceDark});

  final bool isDeviceDark;

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      3,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    _animations = _controllers
        .map(
          (c) => Tween<double>(begin: 0.3, end: 1).animate(
            CurvedAnimation(parent: c, curve: Curves.easeInOut),
          ),
        )
        .toList();

    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) unawaited(_controllers[i].repeat(reverse: true));
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotColor = widget.isDeviceDark ? Colors.white : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (i) => AnimatedBuilder(
          animation: _animations[i],
          builder: (context, _) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor.withValues(alpha: _animations[i].value),
            ),
          ),
        ),
      ),
    );
  }
}
