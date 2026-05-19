import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';

final activeServiceMarqueeId = ValueNotifier<int?>(null);

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.service,
    this.onTap,
  });

  final ServiceEntity service;
  final VoidCallback? onTap;

  void _onLongPress() {
    activeServiceMarqueeId.value =
        activeServiceMarqueeId.value == service.id ? null : service.id;
  }

  void _openServiceDetails(BuildContext context) {
    if (service.id <= 0) return;
    context.push(
      AppRoutes.serviceDetails,
      extra: {'serviceId': service.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return GestureDetector(
      onTap: onTap ?? () => _openServiceDetails(context),
      onLongPress: _onLongPress,
      child: ValueListenableBuilder<int?>(
        valueListenable: activeServiceMarqueeId,
        builder: (context, activeId, child) {
          final isActive = activeId == service.id;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(9.r),
              border: Border.all(
                color: isActive
                    ? cs.primary.withValues(alpha: 0.6)
                    : cs.outlineVariant.withValues(alpha: 0.5),
                width: isActive ? 1.5 : 1.0,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: child,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ServiceImageSection(service: service),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ActiveServiceMarqueeText(
                      serviceId: service.id,
                      text: service.title,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                    4.verticalSpace,
                    if (service.description.isNotEmpty)
                      _ActiveServiceMarqueeText(
                        serviceId: service.id,
                        text: service.description,
                        style: tt.labelSmall?.copyWith(
                          color: context.theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    Text(
                      '${service.price} ${context.l10n.shared_currency_egp}',
                      style: tt.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveServiceMarqueeText extends StatelessWidget {
  const _ActiveServiceMarqueeText({
    required this.serviceId,
    required this.text,
    this.style,
  });

  final int serviceId;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    // FIX 2: ValueListenableBuilder wraps ONLY the reactive part
    // MarqueeText itself changes (isActive), no stable child to hoist here,
    // but we keep the VLB tight around only this text widget — not the whole card
    return ValueListenableBuilder<int?>(
      valueListenable: activeServiceMarqueeId,
      builder: (context, activeId, _) {
        return MarqueeText(
          text: text,
          isActive: activeId == serviceId,
          style: style,
        );
      },
    );
  }
}

class _ServiceImageSection extends StatelessWidget {
  const _ServiceImageSection({required this.service});

  final ServiceEntity service;

  // FIX 10: named method — no new lambda on every BlocSelector rebuild
  void _onFavoriteTap(BuildContext context, bool isFavorite) {
    context.read<FavoriteBloc>().add(
          ToggleServiceFavoriteEvent(
            service.id,
            expectedIsFavorite: isFavorite,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    return SizedBox(
      height: 120.h,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: service.image != null && service.image!.isNotEmpty
                ? CommonImage(
                    imageUrl: service.image!,
                    memCacheHeight: 120 * 3,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(9.r),
                    ),
                  )
                : ColoredBox(
                    color: cs.surfaceContainerLow,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: cs.onSurfaceVariant,
                        size: 40.r,
                      ),
                    ),
                  ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: BlocSelector<FavoriteBloc, FavoriteState, (bool, bool)>(
              selector: (state) => (
                state.serviceFavoriteIds.contains(service.id) ||
                    (state.status == FavoriteStatus.initial &&
                        service.isFavorite),
                state.serviceTogglingIds.contains(service.id),
              ),
              builder: (context, status) {
                final isFavorite = status.$1;
                final isToggling = status.$2;
                return GestureDetector(
                  // FIX 10: named method reference
                  onTap: isToggling ? null : () => _onFavoriteTap(context, isFavorite),
                  child: Container(
                    margin: EdgeInsetsDirectional.symmetric(
                        horizontal: 6.w, vertical: 6.h),
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
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      size: 18.r,
                      color: isFavorite ? cs.error : cs.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
