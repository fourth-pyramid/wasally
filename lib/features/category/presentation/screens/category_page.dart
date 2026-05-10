import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/category_entity.dart';
import 'package:wassaly/features/home/presentation/widgets/category_card.dart';

import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';

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
      body: BlocBuilder<CategoryBloc, CategoryState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.isLoadingMore != current.isLoadingMore ||
            previous.subCategories != current.subCategories,
        builder: (context, state) {
          if (state.status == CategoryStatus.failure) {
            return AppErrorWidget(
              title: 'errors.something_went_wrong'.tr(),
              message: state.errorMessage,
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
            return RefreshIndicator(
              onRefresh: () async {
                final bloc = context.read<CategoryBloc>();
                final startTime = DateTime.now();

                bloc.add(FetchCategoryDetailEvent(category.id));

                await bloc.stream.firstWhere(
                  (state) => state.status != CategoryStatus.loading,
                );

                final elapsed = DateTime.now().difference(startTime);
                if (elapsed < const Duration(seconds: 1)) {
                  await Future<void>.delayed(
                      const Duration(seconds: 1) - elapsed);
                }
              },
              color: cs.primary,
              backgroundColor: cs.surface,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: cs.surface,
                    elevation: 0,
                    centerTitle: true,
                    floating: true,
                    foregroundColor: cs.primary,
                    title: Text(
                      category.name,
                      style: tt.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(16.w),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 1.4,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => const Skeletonizer(
                          ignoreContainers: true,
                          enabled: true,
                          child: CategoryCard(
                            title: 'Sub Category',
                            imageUrl:
                                'https://scontent.fcai19-3.fna.fbcdn.net/v/t39.30808-6/480274848_1231537592319102_5348312428938549056_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=1d70fc&_nc_ohc=lqftgNLcJvUQ7kNvwGt14yl&_nc_oc=AdpgIXfg1Rck4FX6b5O8YswgcdRmZVaAGlWpYkhannm5uA8dYGErmddT2YOEV16UWxE&_nc_zt=23&_nc_ht=scontent.fcai19-3.fna&_nc_gid=Pdj2W7Et4JiExbswPUz3Sg&_nc_ss=7b2a8&oh=00_Af7OvJ0bECoot380m6aLddMhHCeX92jagLSvXBu9ainTtA&oe=69FE5FFA',
                          ),
                        ),
                        childCount: 2,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final subCategories = state.subCategories.data;

          return RefreshIndicator(
            onRefresh: () async {
              final bloc = context.read<CategoryBloc>();
              final startTime = DateTime.now();

              bloc.add(FetchCategoryDetailEvent(category.id));

              await bloc.stream.firstWhere(
                (state) => state.status != CategoryStatus.loading,
              );

              final elapsed = DateTime.now().difference(startTime);
              if (elapsed < const Duration(seconds: 1)) {
                await Future<void>.delayed(
                    const Duration(seconds: 1) - elapsed);
              }
            },
            color: cs.primary,
            backgroundColor: cs.surface,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: cs.surface,
                  elevation: 0,
                  centerTitle: true,
                  floating: true,
                  foregroundColor: cs.primary,
                  title: Text(
                    category.name,
                    style: tt.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ),
                if (subCategories.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppEmptyState(
                      title: 'home.no_sub_categories'.tr(),
                      icon: Icons.folder_open_outlined,
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.all(16.w),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 1.4,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < subCategories.length) {
                            final subCategory = subCategories[index];
                            return CategoryCard(
                              title: subCategory.name,
                              imageUrl: subCategory.image,
                              onTap: () => context.push(
                                AppRoutes.subCategory,
                                extra: {'subCategory': subCategory},
                              ),
                            );
                          }

                          if (state.hasMoreSubCategories) {
                            context.read<CategoryBloc>().add(
                                  LoadMoreSubCategoriesEvent(category.id),
                                );
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                        childCount: subCategories.length +
                            (state.hasMoreSubCategories ? 1 : 0),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
