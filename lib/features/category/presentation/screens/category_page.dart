import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/category/presentation/bloc/category_bloc.dart';
import 'package:wassaly/features/category/presentation/bloc/category_event.dart';
import 'package:wassaly/features/category/presentation/bloc/category_state.dart';
import 'package:wassaly/features/category/presentation/widgets/category_side_menu.dart';
import 'package:wassaly/features/home/domain/entities/category_entity.dart';
import 'package:wassaly/features/home/domain/entities/sub_category_entity.dart';
import 'package:wassaly/features/sub_category/presentation/bloc/sub_category_bloc.dart';
import 'package:wassaly/features/sub_category/presentation/bloc/sub_category_event.dart';
import 'package:wassaly/features/sub_category/presentation/screens/sub_category_page.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({
    super.key,
    required this.category,
  });

  final CategoryEntity category;

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
  const _CategoryView({required this.category});

  final CategoryEntity category;

  // FIX 10: named method — لا closure جديدة في كل rebuild
  void _onRetry(BuildContext context) =>
      context.read<CategoryBloc>().add(FetchCategoryDetailEvent(category.id));

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          // FIX 1: AppSliverTopBar مش بتتغير مع الـ state
          // فأخرجناها بره الـ BlocBuilder تماماً
          AppSliverTopBar(title: category.name),

          // FIX 2: BlocBuilder بس على الـ sliver اللي بيتغير فعلاً
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state.status == CategoryStatus.failure) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppErrorWidget(
                    title: context.l10n.errors_error_occurred_title,
                    message: state.errorMessage.isNotEmpty
                        ? state.errorMessage
                        : context.l10n.errors_error_occurred_message,
                    onRetry: () => _onRetry(context), // FIX 10: named method
                  ),
                );
              }

              final isLoading = state.status == CategoryStatus.loading ||
                  state.status == CategoryStatus.initial;
              final subCategories = state.subCategories.data;

              if (!isLoading && subCategories.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    title: context.l10n.home_no_sub_categories,
                    icon: Icons.folder_open_outlined,
                  ),
                );
              }

              final displaySubCategories = isLoading && subCategories.isEmpty
                  ? List.generate(
                      8,
                      (index) => const SubCategoryEntity(
                        id: 0,
                        name: 'تصنيف تجريبي',
                        image: '',
                      ),
                    )
                  : subCategories;

              final selectedSubCategory = isLoading
                  ? const SubCategoryEntity(
                      id: -1, name: 'تصنيف تجريبي', image: '')
                  : state.selectedSubCategory;

              // FIX 3: حذف الـ Builder الزيادة — الـ BlocBuilder
              // بيديك الـ state مباشرة
              return SliverFillRemaining(
                hasScrollBody: true,
                child: Skeletonizer(
                  enabled: isLoading,
                  ignoreContainers: true,
                  child: Row(
                    children: [
                      CategorySideMenu(
                        isLoading: isLoading,
                        subCategories: displaySubCategories,
                        selectedSubCategoryId: state.selectedSubCategory?.id,
                      ),
                      Expanded(
                        child: selectedSubCategory == null
                            ? const SizedBox.shrink()
                            : KeyedSubtree(
                                key: ValueKey(selectedSubCategory.id),
                                child: BlocProvider(
                                  create: (context) {
                                    final bloc = sl<SubCategoryBloc>();
                                    if (!isLoading) {
                                      bloc.add(FetchSubCategoryDetailEvent(
                                          selectedSubCategory.id));
                                    }
                                    return bloc;
                                  },
                                  // FIX 5: removed single-child Column with no siblings
                                  child: SubCategoryDetailView(
                                    subCategory: selectedSubCategory,
                                    showAppBar: false,
                                    crossAxisCount: 2,
                                    productMainAxisExtent: 230.h,
                                    serviceMainAxisExtent: 190.h,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
