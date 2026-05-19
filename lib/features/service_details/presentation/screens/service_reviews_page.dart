import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_bloc.dart';

import '../../domain/entities/service_detail_entity.dart';
import '../bloc/service_details_bloc.dart';
import '../widgets/service_review_form_sheet.dart';

class ServiceReviewsPage extends StatelessWidget {
  final int serviceId;

  const ServiceReviewsPage({
    super.key,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: BlocConsumer<ServiceDetailsBloc, ServiceDetailsState>(
        listenWhen: (previous, current) =>
            previous.reviewActionStatus != current.reviewActionStatus,
        listener: (context, state) {
          if (state.reviewActionStatus == ReviewActionStatus.success ||
              state.reviewActionStatus == ReviewActionStatus.failure) {
            final message = state.reviewActionMessage == 'product_details_review_created'
                ? context.l10n.product_details_review_created
                : state.reviewActionMessage == 'product_details_review_updated'
                    ? context.l10n.product_details_review_updated
                    : state.reviewActionMessage;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        },
        buildWhen: (previous, current) => previous.service != current.service,
        builder: (context, state) {
          final reviews = state.service?.reviews ?? const [];
          final currentUserId = _currentUserId(context);

          final bookingsState = context.watch<OrdersBloc>().state;
          final bookings = bookingsState.serviceBookings.data;

          final hasCompletedBooking = bookings.any((b) =>
              b.service.id == serviceId &&
              (b.status.trim().toLowerCase() == 'completed' ||
                  b.status.trim() == 'مكتمل'));

          return CustomScrollView(
            slivers: [
              AppSliverTopBar(
                title: context.l10n.product_details_all_reviews,
              ),
              SliverPadding(
                padding: EdgeInsets.all(8.r),
                sliver: SliverList.separated(
                  itemCount: reviews.length,
                  separatorBuilder: (_, __) => 2.verticalSpace,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    final isMine = currentUserId != null &&
                        review.user.id.toString() == currentUserId;

                    return AppReviewCard(
                      rating: review.rating,
                      comment: review.comment,
                      userName: review.user.name,
                      userAvatar: review.user.avatar,
                      isCurrentUserReview: isMine,
                      canEdit: isMine && _canEditReview(review.createdAt) && hasCompletedBooking,
                      createdAt: review.createdAt,
                      onEdit: () => _showReviewSheet(context, review),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String? _currentUserId(BuildContext context) {
    final sessionState = context.watch<SessionBloc>().state;
    return sessionState is SessionAuthenticated ? sessionState.user.id : null;
  }

  bool _canEditReview(String createdAt) {
    final createdDate = DateTime.tryParse(createdAt);
    if (createdDate == null) return false;

    final now = DateTime.now();
    final hasTimezone = RegExp(r'(z|[+-]\d{2}:?\d{2})$', caseSensitive: false)
        .hasMatch(createdAt.trim());
    final candidates = <DateTime>[
      createdDate.toLocal(),
      if (!hasTimezone)
        DateTime.utc(
          createdDate.year,
          createdDate.month,
          createdDate.day,
          createdDate.hour,
          createdDate.minute,
          createdDate.second,
          createdDate.millisecond,
          createdDate.microsecond,
        ).toLocal(),
    ];

    return candidates.any((date) {
      final elapsed = now.difference(date);
      return elapsed >= const Duration(minutes: -5) &&
          elapsed < const Duration(hours: 1);
    });
  }

  void _showReviewSheet(
    BuildContext context,
    ServiceDetailReviewEntity review,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<ServiceDetailsBloc>(),
        child: ServiceReviewFormSheet(
          serviceId: serviceId,
          review: review,
        ),
      ),
    );
  }
}
