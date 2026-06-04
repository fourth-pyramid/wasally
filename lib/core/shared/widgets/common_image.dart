import 'package:wassaly/core/imports/imports.dart';

/// A multi-purpose image widget that handles network images, SVGs, and local assets.
///
/// Automatically uses [CachedNetworkImage] for absolute http URLs and relative
/// API paths (starting with `/`). Relative paths are resolved against [AppConfig.baseUrl].
/// Automatically uses [SvgPicture] for SVG files.
class CommonImage extends StatelessWidget {
  const CommonImage({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.memCacheHeight,
    this.memCacheWidth,
    this.enableFullScreenView = false,
    this.heroTag,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final int? memCacheHeight;
  final int? memCacheWidth;
  final bool enableFullScreenView;
  final String? heroTag;

  /// Resolves a potentially relative path to an absolute URL.
  /// e.g. "/storage/images/foo.jpg" → "https://wasly.bynona.store/storage/images/foo.jpg"
  String get _resolvedUrl {
    if (imageUrl.isEmpty) return '';
    if (imageUrl.startsWith('http')) return imageUrl;
    if (imageUrl.startsWith('/')) return '${AppConfig.baseUrl}$imageUrl';
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final resolved = _resolvedUrl;

    // FIX 11: guard — short-circuit before any other check
    if (resolved.isEmpty) {
      return errorWidget ?? _buildDefaultErrorWidget(context);
    }

    Widget image;

    if (resolved.startsWith('http')) {
      image = AppCachedImage(
        imageUrl: resolved,
        width: width?.w,
        height: height?.h,
        memCacheHeight: memCacheHeight,
        memCacheWidth: memCacheWidth,
        fit: fit,
        color: color,
        placeholder: placeholder,
        errorWidget: errorWidget,
        borderRadius: borderRadius,
      );
    } else if (resolved.endsWith('.svg')) {
      image = SvgPicture.asset(
        resolved,
        width: width?.w,
        height: height?.h,
        fit: fit,
        colorFilter:
            color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      );
    } else {
      // FIX: Automatic cache calculation for local assets.
      final dpr = MediaQuery.devicePixelRatioOf(context);
      final calculatedCacheWidth = memCacheWidth ??
          (width != null && width!.isFinite ? (width! * dpr).round() : null);
      final calculatedCacheHeight = memCacheHeight ??
          (height != null && height!.isFinite ? (height! * dpr).round() : null);

      image = Image.asset(
        resolved,
        cacheHeight: calculatedCacheHeight,
        cacheWidth: calculatedCacheWidth,
        width: width?.w,
        height: height?.h,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? _buildDefaultErrorWidget(context),
      );
    }

    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    if (enableFullScreenView) {
      final tag = heroTag ?? resolved;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          unawaited(
            AppImageFullScreenView.show(
              context,
              imageUrls: [resolved],
              heroTagBuilder: (index) => tag,
            ),
          );
        },
        child: Hero(
          tag: tag,
          child: image,
        ),
      );
    }

    return image;
  }

  // FIX 7: use colorScheme tokens — never hard-coded colors
  Widget _buildDefaultErrorWidget(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Container(
      width: width?.w,
      height: height?.h,
      color: cs.surfaceContainerLow,
      child: Icon(
        Icons.error_outline,
        color: cs.onSurfaceVariant,
      ),
    );
  }
}
