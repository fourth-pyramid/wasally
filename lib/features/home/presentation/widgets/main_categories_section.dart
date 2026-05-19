import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/category_entity.dart';
import 'package:wassaly/features/home/presentation/bloc/home_bloc.dart';
import 'package:wassaly/features/home/presentation/bloc/home_state.dart';
import 'package:wassaly/features/home/presentation/widgets/category_card.dart';

class MainCategoriesSection extends StatelessWidget {
  const MainCategoriesSection({super.key});

  // FIX 10: named method — no new lambdas on every BlocSelector rebuild
  void _onCategoryTap(BuildContext context, CategoryEntity category) =>
      context.push(AppRoutes.category, extra: {'category': category});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocSelector<HomeBloc, HomeState,
        (HomeStatus, List<CategoryEntity>)>(
      selector: (state) => (state.categoriesStatus, state.categories),
      builder: (context, data) {
        final (categoriesStatus, categories) = data;

        if (categoriesStatus == HomeStatus.loading ||
            categoriesStatus == HomeStatus.initial) {
          final dummyCategories = List.generate(
            3,
            (index) => const CategoryEntity(
              id: 0,
              name: 'قسم رئيسي',
              image: '',
            ),
          );

          return Skeletonizer(
            enabled: true,
            child: _buildContent(context, cs, tt, dummyCategories),
          );
        } else if (categoriesStatus == HomeStatus.failure) {
          return const SizedBox.shrink();
        } else if (categories.isEmpty &&
            categoriesStatus == HomeStatus.success) {
          return const SizedBox.shrink();
        }

        return _buildContent(context, cs, tt, categories).animate().fadeIn(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 400),
            );
      },
    );
  }

  Widget _buildContent(BuildContext context, ColorScheme cs, TextTheme tt,
      List<CategoryEntity> categories) {
    if (categories.isEmpty) return const SizedBox.shrink();

    // Show only the first 3 categories
    final displayedCategories = categories.take(3).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.home_main_categories,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
              if (categories.length > 3)
                TextButton(
                  onPressed: () => context.push(AppRoutes.allCategories),
                  child: Text(
                    context.l10n.shared_show_more,
                    style: tt.labelLarge?.copyWith(
                      color: cs.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          16.verticalSpace,

          // Build alternating layout: 1 item, then 2 items, then 1 item...
          ..._buildAlternatingGrid(context, displayedCategories),
        ],
      ),
    );
  }

  List<Widget> _buildAlternatingGrid(
      BuildContext context, List<CategoryEntity> categories) {
    final List<Widget> items = [];
    int i = 0;

    while (i < categories.length) {
      final firstIndex = i;
      // Full Width Item
      items.add(
        Row(
          children: [
            Expanded(
              child: CategoryCard(
                title: categories[firstIndex].name,
                imageUrl: categories[firstIndex].image,
                onTap: () => _onCategoryTap(context, categories[firstIndex]),
              ),
            ),
          ],
        ),
      );
      i++;

      if (i >= categories.length) break;
      items.add(16.verticalSpace);

      final leftIndex = i;
      final rightIndex = i + 1;
      final hasRight = rightIndex < categories.length;

      // Two side-by-side items
      items.add(
        Row(
          children: [
            Expanded(
              child: CategoryCard(
                title: categories[leftIndex].name,
                imageUrl: categories[leftIndex].image,
                onTap: () => _onCategoryTap(context, categories[leftIndex]),
              ),
            ),
            12.horizontalSpace,
            if (hasRight)
              Expanded(
                child: CategoryCard(
                  title: categories[rightIndex].name,
                  imageUrl: categories[rightIndex].image,
                  onTap: () => _onCategoryTap(context, categories[rightIndex]),
                ),
              )
            else
              const Expanded(child: SizedBox.shrink()),
          ],
        ),
      );
      i += 2;

      if (i < categories.length) {
        items.add(16.verticalSpace);
      }
    }

    return items;
  }
}
