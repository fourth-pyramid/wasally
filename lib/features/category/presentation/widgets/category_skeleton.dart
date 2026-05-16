import 'package:wassaly/core/imports/imports.dart';


class CategorySkeleton extends StatelessWidget {
  const CategorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Skeletonizer(
      enabled: true,
      child: Row(
        children: [
          // Left Side: Categories List Skeleton
          Container(
            width: 90.w,
            decoration: BoxDecoration(
              color: cs.surface,
              border: BorderDirectional(
                end: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: 8,
              separatorBuilder: (context, index) => 8.verticalSpace,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 54.r,
                        width: 54.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      8.verticalSpace,
                      Container(
                        height: 10.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Right Side: Details Skeleton
          Expanded(
            child: CustomScrollView(
              slivers: [
                const AppServicesSkeleton(
                  crossAxisCount: 2,
                  childAspectRatio: 0.50,
                ),
                SliverToBoxAdapter(child: 16.verticalSpace),
                const AppProductsSkeleton(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
