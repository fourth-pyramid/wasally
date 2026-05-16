import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/provider_detail_entity.dart';

class ProviderHeader extends StatelessWidget {
  final ProviderDetailEntity provider;

  const ProviderHeader({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            CommonImage(
              imageUrl: provider.cover,
              height: 200.h,
              width: double.infinity,
              memCacheHeight: 200 * 2,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: -50.h,
              child: Container(
                width: 100.w,
                height: 90.h,
                decoration: BoxDecoration(
                  color: cs.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: cs.surface, width: 4.w),
                ),
                child: ClipOval(
                  child: CommonImage(
                    imageUrl: provider.user.avatar ?? '',
                    width: 100.w,
                    height: 90.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        50.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Text(
                provider.title,
                style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_rounded, color: Colors.orange, size: 20.r),
                  4.horizontalSpace,
                  Text(
                    provider.averageRating.toString(),
                    style:
                        tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  8.horizontalSpace,
                  Text(
                    '(${provider.reviewsCount} ${context.l10n.product_details_reviews})',
                    style: tt.bodyMedium?.copyWith(color: cs.outline),
                  ),
                ],
              ),
              16.verticalSpace,
              Text(
                provider.serviceDescription,
                style: tt.bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant, height: 1.5),
                textAlign: TextAlign.center,
              ),
              16.verticalSpace,
            ],
          ),
        ),
      ],
    );
  }
}
