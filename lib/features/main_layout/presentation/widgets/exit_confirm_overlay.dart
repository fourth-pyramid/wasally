import 'package:wassaly/core/imports/imports.dart';

/// Overlay widget shown when the user double-backs to confirm app exit.
class ExitConfirmOverlay extends StatefulWidget {
  const ExitConfirmOverlay({
    required this.message,
    required this.duration,
    super.key,
  });

  final String message;
  final Duration duration;

  @override
  State<ExitConfirmOverlay> createState() => _ExitConfirmOverlayState();
}

class _ExitConfirmOverlayState extends State<ExitConfirmOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  static const _animDuration = Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _animDuration);

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );

    _controller.forward();

    // Begin fade-out slightly before the overlay is removed so the animation
    // completes before the entry is pulled from the overlay stack.
    Future.delayed(widget.duration - _animDuration, () {
      if (mounted) _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 32.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: cs.inverseSurface.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    widget.message,
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onInverseSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
