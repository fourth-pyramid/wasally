import 'package:wassaly/core/imports/imports.dart';

/// A premium, highly customizable wrapper around [CachedNetworkImage].
///
/// This widget provides smooth transitions, specialized error handling,
/// and integrates with the project's design system.
class AppCachedImage extends StatelessWidget {
  /// The URL of the image to display.
  final String imageUrl;

  /// Optional width for the image.
  final double? width;

  /// Optional height for the image.
  final double? height;

  /// How the image should be inscribed into the box.
  final BoxFit fit;

  /// Optional placeholder displayed while the image is loading.
  /// If null, a shimmer or loading indicator is shown.
  final Widget? placeholder;

  /// Optional widget displayed if the image fails to load.
  final Widget? errorWidget;

  /// [Optional] color to be combined with the image.
  final Color? color;

  /// [Optional] blend mode for the [color].
  final BlendMode? colorBlendMode;

  /// The borderRadius of the image.
  final BorderRadius? borderRadius;

  /// The duration of the fade-in animation.
  final Duration? fadeInDuration;

  /// How to align the image within its bounds.
  final Alignment alignment;

  /// If true, the image will be wrapped in a [Skeletonizer] during loading.
  final bool useSkeleton;

  /// Optional key to use for caching.
  final String? cacheKey;

  final int? memCacheHeight;
  final int? memCacheWidth;

  const AppCachedImage({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.color,
    this.colorBlendMode,
    this.borderRadius,
    this.fadeInDuration,
    this.alignment = Alignment.center,
    this.useSkeleton = true,
    this.cacheKey,
    this.memCacheHeight,
    this.memCacheWidth,
  });

  @override
  Widget build(BuildContext context) {
    // FIX 12: removed LayoutBuilder — constraints were never used,
    // only width?.w / height?.h which come from widget props directly
    final adjustedWidth = width?.w;
    final adjustedHeight = height?.h;

    // FIX: Automatic memCache calculation if not provided.
    // This prevents decoding massive images at native size when shown in small widgets.
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final calculatedMemCacheWidth = memCacheWidth ??
        (adjustedWidth != null && adjustedWidth.isFinite
            ? (adjustedWidth * dpr).round()
            : null);
    final calculatedMemCacheHeight = memCacheHeight ??
        (adjustedHeight != null && adjustedHeight.isFinite
            ? (adjustedHeight * dpr).round()
            : null);

    Widget imageContent = CachedNetworkImage(
      imageUrl: imageUrl,
      cacheKey: cacheKey,
      width: adjustedWidth,
      height: adjustedHeight,
      memCacheHeight: calculatedMemCacheHeight,
      memCacheWidth: calculatedMemCacheWidth,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 500),
      placeholder: (context, url) =>
          placeholder ?? _buildDefaultPlaceholder(context),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildDefaultErrorWidget(context),
    );

    if (borderRadius != null) {
      imageContent = ClipRRect(
        borderRadius: borderRadius!,
        child: imageContent,
      );
    }

    return imageContent;
  }

  Widget _buildDefaultPlaceholder(BuildContext context) {
    if (useSkeleton) {
      return Skeletonizer(
        ignoreContainers: true,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surfaceContainerHighest,
            borderRadius: borderRadius,
          ),
        ),
      );
    }
    return _buildLoadingIndicator(context);
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final cs = context.theme.colorScheme;
    final isIOS = context.isIOS;
    return Container(
      width: width,
      height: height,
      color: cs.surfaceContainerHighest.withValues(alpha: 0.9),
      child: Center(
        child: isIOS
            ? CupertinoActivityIndicator(color: cs.primary)
            : CircularProgressIndicator(strokeWidth: 2, color: cs.primary),
      ),
    );
  }

  Widget _buildDefaultErrorWidget(BuildContext context) => SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Image.asset(
            AppAssets.logo,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            cacheHeight: 120,
          ),
        ),
      );
}
