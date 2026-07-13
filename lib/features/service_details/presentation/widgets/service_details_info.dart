import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart' as fav_event;
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:wassaly/features/service_details/domain/entities/service_detail_entity.dart';
import 'package:wassaly/features/service_details/presentation/bloc/service_details_bloc.dart';
import 'package:wassaly/features/service_details/presentation/screens/service_reviews_page.dart';
import 'package:wassaly/features/service_details/presentation/widgets/service_available_days_section.dart';
import 'package:wassaly/features/service_details/presentation/widgets/service_provider_card.dart';
import 'package:wassaly/features/service_details/presentation/widgets/service_review_form_sheet.dart';

class ServiceDetailsInfo extends StatelessWidget {
  final ServiceDetailEntity service;
  final void Function(ServiceAvailableDayEntity?, ServiceAvailableTimeEntity?) onSelectionChanged;

  const ServiceDetailsInfo({
    required this.service,
    required this.onSelectionChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final sessionState = context.watch<SessionBloc>().state;
    final currentUserId = sessionState is SessionAuthenticated ? sessionState.user.id : null;

    final bookingsState = context.watch<OrdersBloc>().state;
    final bookings = bookingsState.serviceBookings.data;

    final hasCompletedBooking = bookings.any(
      (b) => b.service.id == service.id && (b.status.trim().toLowerCase() == 'completed' || b.status.trim() == 'مكتمل'),
    );

    final hasCurrentUserReview =
        currentUserId != null && service.reviews.any((review) => review.user.id.toString() == currentUserId);

    return SliverPadding(
      padding: EdgeInsets.all(16.r),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
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
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: cs.primaryContainer,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                service.category!,
                                style: tt.labelMedium?.copyWith(color: cs.onPrimaryContainer),
                              ),
                            ),
                        ],
                      ),
                    ),
                    BlocSelector<FavoriteBloc, FavoriteState, (bool, bool)>(
                      selector: (state) => (
                        state.serviceFavoriteIds.contains(service.id) ||
                            (state.status == FavoriteStatus.initial && service.isFavorite),
                        state.serviceTogglingIds.contains(service.id),
                      ),
                      builder: (context, status) {
                        final isFavorite = status.$1;
                        final isToggling = status.$2;
                        return IconButton(
                          onPressed: isToggling
                              ? null
                              : () async {
                                  final bloc = context.read<FavoriteBloc>();
                                  await HapticFeedback
                                      .lightImpact(); // ponytail: native light haptic impact on favorite button tap
                                  bloc.add(
                                    fav_event.ToggleServiceFavoriteEvent(
                                      service.id,
                                      expectedIsFavorite: isFavorite,
                                    ),
                                  );
                                },
                          icon: Icon(
                            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isFavorite ? cs.error : cs.outline,
                            size: 28.r,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                24.verticalSpace,
                Text(
                  context.l10n.service_details_description,
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                12.verticalSpace,
                Text(
                  service.description,
                  style: tt.bodyMedium?.copyWith(height: 1.5, color: cs.onSurfaceVariant),
                ),
                24.verticalSpace,
                Text(
                  context.l10n.service_details_provider,
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                12.verticalSpace,
                AppShowcase(
                  showcaseKey: AppShowcaseKeys.serviceProviderCard,
                  title: context.l10n.showcase_service_provider_card_title,
                  description: context.l10n.showcase_service_provider_card_desc,
                  child: ServiceProviderCard(provider: service.provider),
                ),
                24.verticalSpace,
                ServiceAvailableDaysSection(
                  availableDays: service.availableDays,
                  onSelectionChanged: onSelectionChanged,
                ),
                24.verticalSpace,
                (() {
                  final reviews = service.reviews;
                  final averageRating =
                      reviews.isEmpty ? 0.0 : reviews.fold<int>(0, (sum, r) => sum + r.rating) / reviews.length;
                  return AppShowcase(
                    showcaseKey: AppShowcaseKeys.serviceReviewsBtn,
                    title: context.l10n.showcase_service_reviews_btn_title,
                    description: context.l10n.showcase_service_reviews_btn_desc,
                    isLast: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${context.l10n.product_details_reviews} (${reviews.length})',
                          style: tt.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 18.r,
                              color: cs.secondary,
                            ),
                            3.horizontalSpace,
                            Text(
                              averageRating.toStringAsFixed(1),
                              style: tt.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: cs.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                })(),
                if (currentUserId != null && hasCompletedBooking && !hasCurrentUserReview) ...[
                  12.verticalSpace,
                  OutlinedButton.icon(
                    onPressed: () => _showReviewSheet(context),
                    icon: const Icon(Icons.rate_review_outlined),
                    label: Text(context.l10n.product_details_add_review),
                  ),
                ],
                12.verticalSpace,
                if (service.reviews.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Text(
                      context.l10n.service_details_no_reviews_yet,
                      style: tt.bodyMedium?.copyWith(color: cs.outline),
                    ),
                  ),
              ],
            ),
          ),
          if (service.reviews.isNotEmpty)
            SliverList.builder(
              itemCount: service.reviews.length > 3 ? 3 : service.reviews.length,
              itemBuilder: (context, index) {
                final review = service.reviews[index];
                final isMine = currentUserId != null && review.user.id.toString() == currentUserId;

                return AppReviewCard(
                  rating: review.rating,
                  comment: review.comment,
                  userName: review.user.name,
                  userAvatar: review.user.avatar,
                  isCurrentUserReview: isMine,
                  canEdit: isMine && ReviewHelper.canEditReview(review.createdAt) && hasCompletedBooking,
                  createdAt: review.createdAt,
                  onEdit: () => _showReviewSheet(context, review: review),
                );
              },
            ),
          if (service.reviews.length > 3)
            SliverToBoxAdapter(
              child: Column(
                children: [
                  12.verticalSpace,
                  Align(
                    child: TextButton.icon(
                      onPressed: () => _openAllReviews(context),
                      icon: const Icon(Icons.expand_more_rounded),
                      label: Text(context.l10n.product_details_show_more),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showReviewSheet(
    BuildContext context, {
    ServiceDetailReviewEntity? review,
  }) {
    unawaited(
      context.showAppBottomSheet<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<ServiceDetailsBloc>(),
          child: ServiceReviewFormSheet(
            serviceId: service.id,
            review: review,
          ),
        ),
      ),
    );
  }

  void _openAllReviews(BuildContext context) {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider.value(
            value: context.read<ServiceDetailsBloc>(),
            child: ServiceReviewsPage(serviceId: service.id),
          ),
        ),
      ),
    );
  }
}
