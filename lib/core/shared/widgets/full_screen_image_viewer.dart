import 'dart:ui';

import 'package:wassaly/core/imports/imports.dart';

/// A premium, immersive full-screen image viewer supporting multiple images.
/// Supports swiping between images, pinch-to-zoom, pan, double-tap-to-zoom, and vertical swipe to dismiss.
class AppImageFullScreenView extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String Function(int index) heroTagBuilder;

  const AppImageFullScreenView({
    required this.imageUrls,
    required this.initialIndex,
    required this.heroTagBuilder,
    super.key,
  });

  /// Displays the full-screen viewer overlaying the current screen.
  static Future<int?> show(
    BuildContext context, {
    required List<String> imageUrls,
    required String Function(int index) heroTagBuilder,
    int initialIndex = 0,
  }) =>
      Navigator.of(context).push<int>(
        PageRouteBuilder<int>(
          opaque: false,
          barrierDismissible: true,
          barrierColor: Colors.black.withValues(alpha: 0.8),
          pageBuilder: (context, _, __) => AppImageFullScreenView(
            imageUrls: imageUrls,
            initialIndex: initialIndex,
            heroTagBuilder: heroTagBuilder,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      );

  @override
  State<AppImageFullScreenView> createState() => _AppImageFullScreenViewState();
}

class _AppImageFullScreenViewState extends State<AppImageFullScreenView> {
  late final PageController _pageController;
  late final ValueNotifier<int> _currentIndexNotifier;
  // ponytail: Simplified local UI state using ValueNotifier instead of setState or complex Cubits
  late final ValueNotifier<bool> _isZoomedNotifier;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndexNotifier = ValueNotifier<int>(widget.initialIndex);
    _isZoomedNotifier = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndexNotifier.dispose();
    _isZoomedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Blurred backdrop to match rich premium aesthetics
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.65),
                ),
              ),
            ),

            // Image PageView with Swipe-to-Dismiss (Dismissible)
            Positioned.fill(
              child: SafeArea(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isZoomedNotifier,
                  builder: (context, isZoomed, child) => Dismissible(
                    key: const Key('full_screen_image_dismissible'),
                    direction: isZoomed
                        ? DismissDirection.none
                        : DismissDirection.vertical,
                    onDismissed: (_) => Navigator.of(context)
                        .pop(_currentIndexNotifier.value),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.imageUrls.length,
                      physics: isZoomed
                          ? const NeverScrollableScrollPhysics()
                          : const BouncingScrollPhysics(),
                      onPageChanged: (index) {
                        _currentIndexNotifier.value = index;
                        // Reset zoom state when moving to another page
                        _isZoomedNotifier.value = false;
                      },
                      itemBuilder: (context, index) {
                        final imageUrl = widget.imageUrls[index];
                        final heroTag = widget.heroTagBuilder(index);

                        return _FullScreenImagePage(
                          imageUrl: imageUrl,
                          heroTag: heroTag,
                          onScaleChanged: (scale) {
                            _isZoomedNotifier.value = scale > 1.0;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Floating Top Bar with Page Indicator & Close Button
            Positioned(
              top: 20.h,
              left: 20.w,
              right: 20.w,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.imageUrls.length > 1)
                      ValueListenableBuilder<int>(
                        valueListenable: _currentIndexNotifier,
                        builder: (context, currentIndex, _) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            '${currentIndex + 1} / ${widget.imageUrls.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),

                    // Close Button
                    ClipOval(
                      child: Material(
                        color: Colors.black.withValues(alpha: 0.5),
                        child: InkWell(
                          onTap: () => Navigator.of(context)
                              .pop(_currentIndexNotifier.value),
                          child: Padding(
                            padding: EdgeInsets.all(10.r),
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 24.r,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class _FullScreenImagePage extends StatefulWidget {
  final String imageUrl;
  final String heroTag;
  final ValueChanged<double> onScaleChanged;

  const _FullScreenImagePage({
    required this.imageUrl,
    required this.heroTag,
    required this.onScaleChanged,
  });

  @override
  State<_FullScreenImagePage> createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<_FullScreenImagePage>
    with SingleTickerProviderStateMixin {
  late final TransformationController _transformationController;
  late final AnimationController _animationController;
  Animation<Matrix4>? _zoomAnimation;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
        if (_zoomAnimation != null) {
          _transformationController.value = _zoomAnimation!.value;
        }
      });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    final currentMatrix = _transformationController.value;
    const targetScale = 2.5;

    if (currentMatrix != Matrix4.identity()) {
      // Zoom out to original scale
      _zoomAnimation = Matrix4Tween(
        begin: currentMatrix,
        end: Matrix4.identity(),
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
      unawaited(_animationController.forward(from: 0.0));
      widget.onScaleChanged(1.0);
    } else {
      // Zoom in to double tap position
      final position = _doubleTapDetails?.localPosition ?? Offset.zero;
      final x = -position.dx * (targetScale - 1);
      final y = -position.dy * (targetScale - 1);

      // ignore: deprecated_member_use
      final targetMatrix = Matrix4.identity()
        // ignore: deprecated_member_use
        ..translate(x, y)
        // ignore: deprecated_member_use
        ..scale(targetScale);

      _zoomAnimation = Matrix4Tween(
        begin: currentMatrix,
        end: targetMatrix,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
      unawaited(_animationController.forward(from: 0.0));
      widget.onScaleChanged(targetScale);
    }
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Hero(
          tag: widget.heroTag,
          child: GestureDetector(
            onDoubleTapDown: (details) => _doubleTapDetails = details,
            onDoubleTap: _handleDoubleTap,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 1.0,
              maxScale: 4.0,
              onInteractionStart: (_) {
                if (_animationController.isAnimating) {
                  _animationController.stop();
                }
              },
              onInteractionUpdate: (_) {
                final scale =
                    _transformationController.value.getMaxScaleOnAxis();
                widget.onScaleChanged(scale);
              },
              onInteractionEnd: (_) {
                final scale =
                    _transformationController.value.getMaxScaleOnAxis();
                widget.onScaleChanged(scale);
              },
              child: CommonImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
      );
}
