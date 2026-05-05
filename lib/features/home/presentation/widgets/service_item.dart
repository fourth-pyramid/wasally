import 'package:wassaly/core/imports/imports.dart';

class ServiceItem extends StatelessWidget {
  const ServiceItem({
    super.key,
    required this.name,
    required this.imageUrl,
    this.onTap,
  });

  final String name;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 12.w),
        child: Column(
          children: [
            Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: CommonImage(
                memCacheHeight: 64 * 3,
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            4.verticalSpace,
            Text(
              name,
              style: tt.bodySmall?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
