import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/category_entity.dart';
import 'package:wassaly/features/home/presentation/bloc/home_bloc.dart';
import 'package:wassaly/features/home/presentation/bloc/home_event.dart';
import 'package:wassaly/features/home/presentation/bloc/home_state.dart';
import 'package:wassaly/features/home/presentation/widgets/category_card.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = context.theme.colorScheme;

    return ShowCaseWidget(
      showcaseId: 'all_categories_v1',
      enableAutoScroll: true,
      disableBarrierInteraction: true,
      onShouldStartShowcase: (id) async => !StorageService.instance.hasSeenShowcase(id!),
      onFinish: () {
        unawaited(StorageService.instance.setHasSeenShowcase('all_categories_v1', value: true));
      },
      builder: Builder(
        builder: (context) => Scaffold(
          backgroundColor: cs.surface,
          body: CustomScrollView(
            slivers: [
              AppSliverTopBar(
                title: l10n.home_main_categories,
                pinned: true,
              ),
              BlocSelector<HomeBloc, HomeState, (HomeStatus, List<CategoryEntity>, String)>(
                selector: (state) => (
                  state.categoriesStatus,
                  state.categories,
                  state.errorMessage,
                ),
                builder: (context, data) {
                  final (categoriesStatus, categories, errorMessage) = data;

                  if (categoriesStatus == HomeStatus.loading || categoriesStatus == HomeStatus.initial) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: AppLoading(),
                      ),
                    );
                  }

                  if (categoriesStatus == HomeStatus.failure) {
                    return SliverFillRemaining(
                      child: AppErrorWidget(
                        message: errorMessage,
                        onRetry: () => context.read<HomeBloc>().add(GetCategoriesEvent()),
                      ),
                    );
                  }

                  if (categories.isEmpty) {
                    return SliverFillRemaining(
                      child: AppEmptyState(
                        title: l10n.home_no_sub_categories,
                        icon: Icons.category_outlined,
                      ),
                    );
                  }

                  if (categoriesStatus == HomeStatus.success) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) {
                        ShowCaseWidget.of(context).startShowCase([
                          AppShowcaseKeys.allCategoriesGrid,
                        ]);
                      }
                    });
                  }

                  return SliverPadding(
                    padding: EdgeInsets.all(12.r),
                    sliver: SliverToBoxAdapter(
                      child: AppShowcase(
                        showcaseKey: AppShowcaseKeys.allCategoriesGrid,
                        title: context.l10n.showcase_all_categories_grid_title,
                        description: context.l10n.showcase_all_categories_grid_desc,
                        isLast: true,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12.h,
                            crossAxisSpacing: 12.w,
                            childAspectRatio: 1.3,
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return CategoryCard(
                              title: category.name,
                              imageUrl: category.image,
                              onTap: () => context.push(
                                AppRoutes.category,
                                extra: {'category': category},
                              ),
                            ).animate().fadeIn(
                                  delay: Duration(milliseconds: index * 50),
                                  duration: const Duration(milliseconds: 300),
                                );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
