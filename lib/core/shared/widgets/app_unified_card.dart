import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';

enum UnifiedItemType { product, service }

/// A unified card widget that can represent both products and services.
/// It adaptively shows specific UI elements based on the [type] and provided data.
class AppUnifiedCard extends StatelessWidget {
  const AppUnifiedCard({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    super.key,
    this.type = UnifiedItemType.product,
    this.description,
    this.originalPrice,
    this.discountPercentage,
    this.rating,
    this.reviewCount,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
    this.onActionTap,
    this.activeIdNotifier,
  });

  final int id;
  final String title;
  final String? image;
  final String price;
  final UnifiedItemType type;
  final String? description;
  final String? originalPrice;
  final int? discountPercentage;
  final double? rating;
  final int? reviewCount;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onActionTap;
  final ValueNotifier<int?>? activeIdNotifier;

  bool get hasOffer => discountPercentage != null && discountPercentage! > 0;

  void _onLongPress() {
    if (activeIdNotifier != null) {
      activeIdNotifier!.value = activeIdNotifier!.value == id ? null : id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        onLongPress: _onLongPress,
        child: _ActiveBorderWrapper(
          id: id,
          activeIdNotifier: activeIdNotifier,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImageSection(
                id: id,
                image: image,
                isFavorite: isFavorite,
                type: type,
                discountPercentage: discountPercentage,
                onFavoriteTap: onFavoriteTap,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(6),
                    vertical: type == UnifiedItemType.product
                        ? context.h(4)
                        : context.h(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (description != null && description!.isNotEmpty)
                        _MarqueeWrapper(
                          id: id,
                          text: description!,
                          activeIdNotifier: activeIdNotifier,
                          style: tt.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      if (type == UnifiedItemType.product) context.vS(4),
                      _MarqueeWrapper(
                        id: id,
                        text: title,
                        activeIdNotifier: activeIdNotifier,
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      const Spacer(),
                      if (type == UnifiedItemType.product &&
                          rating != null &&
                          reviewCount != null &&
                          reviewCount! > 0)
                        _RatingRow(rating: rating!, reviewCount: reviewCount!),
                      _PriceRow(
                        price: price,
                        originalPrice: originalPrice,
                        hasOffer: hasOffer,
                        type: type,
                        onActionTap: onActionTap,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveBorderWrapper extends StatelessWidget {
  const _ActiveBorderWrapper({
    required this.id,
    required this.child,
    this.activeIdNotifier,
  });

  final int id;
  final Widget child;
  final ValueNotifier<int?>? activeIdNotifier;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    if (activeIdNotifier == null) {
      return Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(context.r(12)),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: child,
      );
    }

    return ValueListenableBuilder<int?>(
      valueListenable: activeIdNotifier!,
      builder: (context, activeId, widget) {
        final isActive = activeId == id;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(context.r(12)),
            border: Border.all(
              color: isActive
                  ? cs.primary.withValues(alpha: 0.6)
                  : cs.outlineVariant.withValues(alpha: 0.5),
              width: isActive ? 1.5 : 1.0,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: widget,
        );
      },
      child: child,
    );
  }
}

class _MarqueeWrapper extends StatelessWidget {
  const _MarqueeWrapper({
    required this.id,
    required this.text,
    this.activeIdNotifier,
    this.style,
  });

  final int id;
  final String text;
  final ValueNotifier<int?>? activeIdNotifier;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (activeIdNotifier == null) {
      return Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return ValueListenableBuilder<int?>(
      valueListenable: activeIdNotifier!,
      builder: (context, activeId, _) => MarqueeText(
        text: text,
        isActive: activeId == id,
        style: style,
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection({
    required this.id,
    required this.image,
    required this.isFavorite,
    required this.type,
    this.discountPercentage,
    this.onFavoriteTap,
  });

  final int id;
  final String? image;
  final bool isFavorite;
  final UnifiedItemType type;
  final int? discountPercentage;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final imageHeight = context.responsiveValue(
      mobile: type == UnifiedItemType.product ? context.h(140) : context.h(120),
      tablet: type == UnifiedItemType.product ? context.h(180) : context.h(150),
      desktop:
          type == UnifiedItemType.product ? context.h(220) : context.h(180),
    );

    return SizedBox(
      height: imageHeight,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: image != null && image!.isNotEmpty
                ? CommonImage(
                    height: type == UnifiedItemType.product ? 140 : 120,
                    memCacheHeight:
                        (type == UnifiedItemType.product ? 140 : 120) * 3,
                    imageUrl: image!,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(context.r(9)),
                    ),
                  )
                : ColoredBox(
                    color: cs.surfaceContainerLow,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: cs.onSurfaceVariant,
                        size: context.r(40),
                      ),
                    ),
                  ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: BlocSelector<FavoriteBloc, FavoriteState, (bool, bool)>(
              selector: (state) {
                if (type == UnifiedItemType.product) {
                  return (
                    state.favoriteIds.contains(id) ||
                        (!state.hasLoaded && isFavorite),
                    state.togglingIds.contains(id),
                  );
                } else {
                  return (
                    state.serviceFavoriteIds.contains(id) ||
                        (state.status == FavoriteStatus.initial && isFavorite),
                    state.serviceTogglingIds.contains(id),
                  );
                }
              },
              builder: (context, status) {
                final isFav = status.$1;
                final isToggling = status.$2;
                return GestureDetector(
                  onTap: isToggling
                      ? null
                      : onFavoriteTap ??
                          () {
                            final event = type == UnifiedItemType.product
                                ? ToggleFavoriteEvent(
                                    id,
                                    expectedIsFavorite: isFav,
                                  )
                                : ToggleServiceFavoriteEvent(
                                    id,
                                    expectedIsFavorite: isFav,
                                  );
                            context.read<FavoriteBloc>().add(event);
                          },
                  child: Container(
                    margin: EdgeInsetsDirectional.symmetric(
                      horizontal: context.w(6),
                      vertical: context.h(6),
                    ),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: cs.shadow.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      size: context.r(18),
                      color: isFav ? cs.error : cs.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
          ),
          if (type == UnifiedItemType.product &&
              discountPercentage != null &&
              discountPercentage! > 0)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsetsDirectional.symmetric(
                  horizontal: context.w(6),
                  vertical: context.h(6),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(8),
                  vertical: context.h(6),
                ),
                decoration: BoxDecoration(
                  color: cs.error,
                  borderRadius: BorderRadius.circular(context.r(4)),
                ),
                child: Text(
                  '$discountPercentage%-',
                  style: TextStyle(
                    color: cs.onError,
                    fontSize: context.sp(11),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.rating, required this.reviewCount});

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;
    return Row(
      children: [
        Icon(
          Icons.star_rounded,
          size: context.r(14),
          color: cs.secondary,
        ),
        context.hS(2),
        Text(
          '${rating.toStringAsFixed(1)} ($reviewCount)',
          style: tt.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.price,
    required this.type,
    this.originalPrice,
    this.hasOffer = false,
    this.onActionTap,
  });

  final String price;
  final String? originalPrice;
  final bool hasOffer;
  final UnifiedItemType type;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colors;
    final tt = context.textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (type == UnifiedItemType.product &&
                  hasOffer &&
                  originalPrice != null)
                Text(
                  '$originalPrice ${context.l10n.shared_currency_egp}',
                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: cs.error,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              Text(
                '$price ${context.l10n.shared_currency_egp}',
                style: (type == UnifiedItemType.product
                        ? tt.titleSmall
                        : tt.labelMedium)
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: type == UnifiedItemType.product
                      ? cs.onSurface
                      : cs.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (type == UnifiedItemType.product) ...[
          context.hS(4),
          GestureDetector(
            onTap: onActionTap,
            child: Container(
              padding: EdgeInsets.all(context.r(8)),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(context.r(8)),
              ),
              child: Icon(
                Icons.remove_red_eye,
                size: context.r(18),
                color: cs.onPrimary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
