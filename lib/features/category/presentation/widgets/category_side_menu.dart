import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/category/presentation/bloc/category_bloc.dart';
import 'package:wassaly/features/category/presentation/bloc/category_event.dart';
import 'package:wassaly/features/home/domain/entities/sub_category_entity.dart';

class CategorySideMenu extends StatelessWidget {
  final bool isLoading;
  final List<SubCategoryEntity> subCategories;
  final int? selectedSubCategoryId;

  const CategorySideMenu({
    super.key,
    required this.isLoading,
    required this.subCategories,
    required this.selectedSubCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
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
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            sliver: SliverList.builder(
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                final item = subCategories[index];
                final isSelected =
                    !isLoading && selectedSubCategoryId == item.id;

                return Column(
                  children: [
                    if (index > 0) 8.verticalSpace,
                    GestureDetector(
                      onTap: isLoading
                          ? null
                          : () {
                              context
                                  .read<CategoryBloc>()
                                  .add(SelectSubCategoryEvent(item));
                            },
                      child: AnimatedContainer(
                        width: double.infinity,
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? cs.primary.withValues(alpha: 0.08)
                              : Colors.transparent,
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            // Selection Indicator
                            if (isSelected)
                              PositionedDirectional(
                                start: -4.w,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 4.w,
                                  decoration: BoxDecoration(
                                    color: cs.primary,
                                    borderRadius: BorderRadiusDirectional.only(
                                      topEnd: Radius.circular(4.r),
                                      bottomEnd: Radius.circular(4.r),
                                    ),
                                  ),
                                ),
                              ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 48.h,
                                  width: 54.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: cs.surface,
                                    border: Border.all(
                                      color: isSelected
                                          ? cs.primary
                                          : cs.outlineVariant.withValues(
                                              alpha: 0.5,
                                            ),
                                      width: isSelected ? 2 : 1,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: cs.primary.withValues(
                                                alpha: 0.2,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: ClipOval(
                                    child: CommonImage(
                                      imageUrl: item.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                8.verticalSpace,
                                Text(
                                  item.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: tt.labelSmall?.copyWith(
                                    color: isSelected
                                        ? cs.primary
                                        : cs.onSurfaceVariant,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    fontSize: 11.sp,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
