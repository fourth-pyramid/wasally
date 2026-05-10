import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';

import '../../domain/entities/product_detail_entity.dart';
import '../bloc/product_details_bloc.dart';
import '../bloc/product_details_state.dart';
import '../widgets/product_review_card.dart';
import '../widgets/product_review_form_sheet.dart';

class ProductReviewsPage extends StatelessWidget {
  final int productId;

  const ProductReviewsPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
        listenWhen: (previous, current) =>
            previous.reviewActionStatus != current.reviewActionStatus,
        listener: (context, state) {
          if (state.reviewActionStatus == ReviewActionStatus.success ||
              state.reviewActionStatus == ReviewActionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.reviewActionMessage)),
            );
          }
        },
        buildWhen: (previous, current) => previous.product != current.product,
        builder: (context, state) {
          final reviews = state.product?.reviews ?? const [];
          final currentUserId = _currentUserId(context);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: cs.surface,
                foregroundColor: cs.primary,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  'product_details.all_reviews'.tr(),
                  style: context.theme.textTheme.titleLarge?.copyWith(
                    color: cs.primary,
                  ),
                ),
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

                    return ProductReviewCard(
                      review: review,
                      isCurrentUserReview: isMine,
                      canEdit: isMine && _canEditReview(review.createdAt),
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
    ProductDetailReviewEntity review,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<ProductDetailsBloc>(),
        child: ProductReviewFormSheet(
          productId: productId,
          review: review,
        ),
      ),
    );
  }
}
