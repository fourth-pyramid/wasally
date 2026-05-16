import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';

import '../../domain/entities/service_detail_entity.dart';
import 'service_available_days_section.dart';
import 'service_provider_card.dart';

class ServiceDetailsInfo extends StatelessWidget {
  final ServiceDetailEntity service;
  final void Function(ServiceAvailableDayEntity?, ServiceAvailableTimeEntity?)
      onSelectionChanged;

  const ServiceDetailsInfo({
    super.key,
    required this.service,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.service,
                      style: tt.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                    8.verticalSpace,
                    if (service.category != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          service.category!,
                          style: tt.labelMedium
                              ?.copyWith(color: cs.onPrimaryContainer),
                        ),
                      ),
                  ],
                ),
              ),
              BlocSelector<FavoriteBloc, FavoriteState, (bool, bool)>(
                selector: (state) => (
                  state.serviceFavoriteIds.contains(service.id) ||
                      (state.status == FavoriteStatus.initial &&
                          service.isFavorite),
                  state.serviceTogglingIds.contains(service.id),
                ),
                builder: (context, status) {
                  final isFavorite = status.$1;
                  final isToggling = status.$2;
                  return IconButton(
                    onPressed: isToggling
                        ? null
                        : () => context.read<FavoriteBloc>().add(
                              ToggleServiceFavoriteEvent(
                                service.id,
                                expectedIsFavorite: isFavorite,
                              ),
                            ),
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFavorite ? cs.error : cs.outline,
                      size: 28.r,
                    ),
                  );
                },
              ),
            ],
          ),
          16.verticalSpace,
          Text(
            context.l10n.service_details_description,
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          8.verticalSpace,
          Text(
            service.description,
            style: tt.bodyMedium
                ?.copyWith(height: 1.5, color: cs.onSurfaceVariant),
          ),
          24.verticalSpace,
          Text(
            context.l10n.service_details_provider,
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          12.verticalSpace,
          ServiceProviderCard(provider: service.provider),
          24.verticalSpace,
          ServiceAvailableDaysSection(
            availableDays: service.availableDays,
            onSelectionChanged: onSelectionChanged,
          ),
          24.verticalSpace,
          Text(
            context.l10n.product_details_reviews,
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          8.verticalSpace,
          if (service.reviews.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                'لا توجد تقييمات بعد',
                style: tt.bodyMedium?.copyWith(color: cs.outline),
              ),
            )
          else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount:
                  service.reviews.length > 3 ? 3 : service.reviews.length,
              separatorBuilder: (_, __) => 12.verticalSpace,
              itemBuilder: (context, index) {
                final review = service.reviews[index];
                return AppReviewCard(
                  rating: review.rating,
                  comment: review.comment,
                  userName: review.user.name,
                  userAvatar: review.user.avatar,
                );
              },
            ),
            if (service.reviews.length > 3) ...[
              12.verticalSpace,
              Align(
                alignment: Alignment.center,
                child: TextButton.icon(
                  onPressed: () {
                    // TODO: Show all reviews page
                  },
                  icon: const Icon(Icons.expand_more_rounded),
                  label: Text(context.l10n.product_details_show_more),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
