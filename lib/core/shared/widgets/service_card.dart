import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';

final activeServiceMarqueeId = ValueNotifier<int?>(null);


class ServiceCard extends StatefulWidget {
  final ServiceEntity service;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.service,
    this.onTap,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    activeServiceMarqueeId.addListener(_onActiveIdChanged);
  }

  @override
  void dispose() {
    activeServiceMarqueeId.removeListener(_onActiveIdChanged);
    if (activeServiceMarqueeId.value == widget.service.id) {
      activeServiceMarqueeId.value = null;
    }
    super.dispose();
  }

  void _onActiveIdChanged() {
    final isNowActive = activeServiceMarqueeId.value == widget.service.id;
    if (isNowActive != _isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _isActive = isNowActive);
        }
      });
    }
  }

  void _onLongPress() {
    if (activeServiceMarqueeId.value == widget.service.id) {
      activeServiceMarqueeId.value = null;
    } else {
      activeServiceMarqueeId.value = widget.service.id;
    }
  }

  void _openServiceDetails(BuildContext context) {
    if (widget.service.id <= 0) return;

    context.push(
      AppRoutes.serviceDetails,
      extra: {'serviceId': widget.service.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return GestureDetector(
      onTap: widget.onTap ?? () => _openServiceDetails(context),
      onLongPress: _onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(
            color: _isActive
                ? cs.primary.withValues(alpha: 0.6)
                : cs.outlineVariant.withValues(alpha: 0.5),
            width: _isActive ? 1.5 : 1.0,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            SizedBox(
              height: 120.h,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: widget.service.image != null &&
                            widget.service.image!.isNotEmpty
                        ? CommonImage(
                            imageUrl: widget.service.image!,
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
                    child:
                        BlocSelector<FavoriteBloc, FavoriteState, (bool, bool)>(
                      selector: (state) => (
                        state.serviceFavoriteIds.contains(widget.service.id) ||
                            (state.status == FavoriteStatus.initial &&
                                widget.service.isFavorite),
                        state.serviceTogglingIds.contains(widget.service.id),
                      ),
                      builder: (context, status) {
                        final isFavorite = status.$1;
                        final isToggling = status.$2;
                        return GestureDetector(
                          onTap: isToggling
                              ? null
                              : () {
                                  context.read<FavoriteBloc>().add(
                                        ToggleServiceFavoriteEvent(
                                          widget.service.id,
                                          expectedIsFavorite: isFavorite,
                                        ),
                                      );
                                },
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
                              color:
                                  isFavorite ? cs.error : cs.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Content section
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 8.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    MarqueeText(
                      text: widget.service.title,
                      isActive: _isActive,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    4.verticalSpace,

                    // Description
                    if (widget.service.description.isNotEmpty)
                      MarqueeText(
                        text: widget.service.description,
                        isActive: _isActive,
                        style: tt.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),

                    // const Spacer(),

                    // Price
                    Text(
                      '${widget.service.price} ${context.l10n.shared_currency_egp}',
                      style: tt.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
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
