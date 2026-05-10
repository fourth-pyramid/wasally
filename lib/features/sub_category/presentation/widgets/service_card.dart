import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';

class ServiceCard extends StatelessWidget {
  final ServiceEntity service;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.service,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            SizedBox(
              height: 140.h,
              width: double.infinity,
              child: service.image != null && service.image!.isNotEmpty
                  ? AppCachedImage(
                      imageUrl: service.image!,
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

            // Content section
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      service.title,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.h.verticalSpace,

                    // Description
                    if (service.description.isNotEmpty)
                      Text(
                        service.description,
                        style: tt.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
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
