import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/category_entity.dart';
import 'package:wassaly/features/sub_category/presentation/bloc/sub_category_bloc.dart';
import 'package:wassaly/features/sub_category/presentation/bloc/sub_category_event.dart';
import 'package:wassaly/features/sub_category/presentation/screens/sub_category_page.dart';

import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';
import '../widgets/widgets.dart';

class CategoryPage extends StatelessWidget {
  final CategoryEntity category;

  const CategoryPage({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<CategoryBloc>()..add(FetchCategoryDetailEvent(category.id)),
      child: _CategoryView(category: category),
    );
  }
}

class _CategoryView extends StatelessWidget {
  final CategoryEntity category;

  const _CategoryView({required this.category});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppTopBar(
        title: category.name,
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state.status == CategoryStatus.failure) {
            return AppErrorWidget(
              title: context.l10n.errors_error_occurred_title,
              message: state.errorMessage.isNotEmpty
                  ? state.errorMessage
                  : context.l10n.errors_error_occurred_message,
              onRetry: () {
                context.read<CategoryBloc>().add(
                      FetchCategoryDetailEvent(category.id),
                    );
              },
            );
          }

          final isLoading = state.status == CategoryStatus.loading ||
              state.status == CategoryStatus.initial;

          if (isLoading) {
            return const CategorySkeleton();
          }

          final subCategories = state.subCategories.data;

          if (subCategories.isEmpty) {
            return AppEmptyState(
              title: context.l10n.home_no_sub_categories,
              icon: Icons.folder_open_outlined,
            );
          }

          return Row(
            children: [
              // Left Side: Categories List
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
                  itemCount: subCategories.length,
                  separatorBuilder: (context, index) => 8.verticalSpace,
                  itemBuilder: (context, index) {
                    final item = subCategories[index];
                    final isSelected = state.selectedSubCategory?.id == item.id;

                    return GestureDetector(
                      onTap: () {
                        context
                            .read<CategoryBloc>()
                            .add(SelectSubCategoryEvent(item));
                      },
                      child: AnimatedContainer(
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
                                  height: 54.r,
                                  width: 54.r,
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
                    );
                  },
                ),
              ),

              // Right Side: SubCategory Detail View
              Expanded(
                child: state.selectedSubCategory == null
                    ? const SizedBox.shrink()
                    : KeyedSubtree(
                        key: ValueKey(state.selectedSubCategory!.id),
                        child: BlocProvider(
                          create: (context) => sl<SubCategoryBloc>()
                            ..add(FetchSubCategoryDetailEvent(
                                state.selectedSubCategory!.id)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SubCategoryDetailView(
                                  subCategory: state.selectedSubCategory!,
                                  showAppBar: false,
                                  crossAxisCount: 2,
                                  productMainAxisExtent: 230.h,
                                  serviceMainAxisExtent: 190.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
