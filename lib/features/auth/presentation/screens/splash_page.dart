import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SplashView();
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Animations — all driven by a single controller with staggered intervals
  late final Animation<double> _logoSlide; // logo moves up
  late final Animation<double> _bgFade; // factor for white → primary
  late final Animation<double> _contentFade; // text + dots appear
  late final Animation<double> _contentSlide; // text slides up slightly

  // Track initialization state
  final Completer<void> _initCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Start initialization in parallel with animation
    _initializeServices();

    // ── Staggered intervals ──────────────────────────────────────────────
    //
    //  0.0 ─────── 0.35 ──── 0.65 ──── 1.0
    //  │  bg color  │  logo↑  │ content │
    //
    // Background starts changing immediately
    _bgFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.4, curve: Curves.easeInOut),
    );

    // Logo slides up after bg starts (overlapping slightly)
    _logoSlide = Tween<double>(begin: 0, end: -140.h).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.6, curve: Curves.easeInOutCubic),
      ),
    );

    // Content fades in after logo settles
    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.85, curve: Curves.easeOut),
      ),
    );

    // Content slides up slightly as it fades in
    _contentSlide = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _startAnimation();
  }

  /// Initialize heavy services in parallel with splash animation
  Future<void> _initializeServices() async {
    try {
      // الحاجات اللي كانت في AppBootstrap / main
      await dotenv.load(fileName: '.env');
      await StorageService.instance.init();
      await AppConfig.init();
      await DeepLinkService.instance.initialize();
    } catch (e) {
      AppLogger.error('Splash init error: $e');
    } finally {
      if (mounted && !_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    }
  }

  Future<void> _startAnimation() async {
    // تقليل التأخير للحد الأدنى لتقليل الإحساس بالفجوة الزمنية
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;

    // Run animation and initialization in parallel
    final animationFuture = _controller.forward();

    // Wait for both animation and initialization to complete
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
      case SessionAuthenticated():
        context.go(AppRoutes.home);
      case SessionUnauthenticated() || SessionError():
        context.go(AppRoutes.login);
      default:
        // Wait for BlocListener if state is still SessionInitial
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
    const logoSize = 180;
    final isDark = context.isDarkMode;

    return BlocListener<SessionBloc, SessionState>(
      listener: (context, state) {
        if (_controller.isCompleted) {
          _handleNavigation(state);
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        // نضع اللوجو هنا كـ child ثابت لمنع إعادة بناء الـ Widget الخاص بالصورة
        child: Container(
          width: logoSize.w,
          height: logoSize.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.asset(
              'assets/images/logo.png',
              width: logoSize.w,
              height: logoSize.h,
              cacheHeight: logoSize * 2,
              cacheWidth: logoSize * 2,
              fit: BoxFit.contain,
            ),
          ),
        ),
        builder: (context, logoWidget) {
          final centerY = (screenH - logoSize) / 2;
          final logoY = centerY + _logoSlide.value;

          // Theme-aware background colors
          final startColor =
              isDark ? context.colors.surface : context.colors.surface;
          final endColor = context.colors.primary;

          final bgColor = Color.lerp(
            startColor,
            endColor,
            _bgFade.value,
          );

          return Scaffold(
            backgroundColor: bgColor,
            body: Stack(
              children: [
                // ── Logo ─────────────────────────────────────────────
                Positioned(
                  top: logoY,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: logoWidget, // استخدام النسخة الثابتة المحملة مسبقاً
                  ),
                ),

                // ── Subtitle (Fixed at bottom) ──────────────────────
                Positioned(
                  bottom: 110.h,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: _contentFade.value,
                    child: Transform.translate(
                      offset: Offset(0, _contentSlide.value),
                      child: Text(
                        context.l10n.auth_splash_subtitle,
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color:
                              context.colors.onPrimary.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Loading dots ─────────────────────────────────────
                Positioned(
                  bottom: 60.h,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: _contentFade.value,
                    child: _PulsingDots(isDark: isDark),
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

// ─────────────────────────────────────────────────────────────────────────────
// 3 نقط بتتنبض
// ─────────────────────────────────────────────────────────────────────────────

class _PulsingDots extends StatefulWidget {
  const _PulsingDots({required this.isDark});

  final bool isDark;

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
        .map((c) => Tween<double>(begin: 0.3, end: 1).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOut),
            ))
        .toList();

    // كل نقطة تبدأ بـ delay مختلف عشان تبان wave effect
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) _controllers[i].repeat(reverse: true);
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (context, _) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.onPrimary
                    .withValues(alpha: _animations[i].value),
              ),
            );
          },
        );
      }),
    );
  }
}
