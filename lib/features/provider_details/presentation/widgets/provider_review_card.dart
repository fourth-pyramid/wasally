import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/provider_detail_entity.dart';

class ProviderReviewCard extends StatelessWidget {
  final ProviderDetailReviewEntity review;

  const ProviderReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    final tt = context.theme.textTheme;

    return AppCard(
      showShadow: true,
      padding: EdgeInsets.all(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < review.rating
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: Colors.orange,
                size: 16.r,
              ),
            ),
          ),
          if (review.comment.isNotEmpty) ...[
            8.verticalSpace,
            Text(
              review.comment,
              style: tt.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
