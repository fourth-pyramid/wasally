import 'package:wassaly/core/imports/imports.dart';

/// A multi-purpose image widget that handles network images, SVGs, and local assets.
///
/// Automatically uses [CachedNetworkImage] for absolute http URLs and relative
/// API paths (starting with `/`). Relative paths are resolved against [AppConfig.baseUrl].
/// Automatically uses [SvgPicture] for SVG files.
class CommonImage extends StatelessWidget {
  const CommonImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.memCacheHeight,
    this.memCacheWidth,
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
        width: width,
        height: height,
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
      image = Image.asset(
        resolved,
        cacheHeight: memCacheHeight,
        cacheWidth: memCacheWidth,
        width: width?.w,
        height: height?.h,
        fit: fit,
        color: color,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? _buildDefaultErrorWidget(context),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }

  // FIX 7: use colorScheme tokens — never hard-coded colors
  Widget _buildDefaultErrorWidget(BuildContext context) {
    final cs = context.theme.colorScheme;
    return Container(
      width: width,
      height: height,
      color: cs.surfaceContainerLow,
      child: Icon(
        Icons.error_outline,
        color: cs.onSurfaceVariant,
      ),
    );
  }
}
