import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/category_entity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import 'category_card.dart';

class MainCategoriesSection extends StatelessWidget {
  const MainCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.categoriesStatus != current.categoriesStatus ||
          previous.categories != current.categories,
      builder: (context, state) {
        if (state.categoriesStatus == HomeStatus.loading ||
            state.categoriesStatus == HomeStatus.initial) {
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
        } else if (state.categoriesStatus == HomeStatus.failure) {
          return const SizedBox.shrink();
        } else if (state.categories.isEmpty &&
            state.categoriesStatus == HomeStatus.success) {
          return const SizedBox.shrink();
        }

        return _buildContent(context, cs, tt, state.categories)
            .animate()
            .fadeIn(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 400),
            );
      },
    );
  }

  Widget _buildContent(BuildContext context, ColorScheme cs, TextTheme tt,
      List<CategoryEntity> categories) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'الأقسام الرئيسية',
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
          16.verticalSpace,

          // Build alternating layout: 1 item, then 2 items, then 1 item...
          ..._buildAlternatingGrid(context, categories),
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
                onTap: () => context.push(
                  AppRoutes.category,
                  extra: {'category': categories[firstIndex]},
                ),
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
                onTap: () => context.push(
                  AppRoutes.category,
                  extra: {'category': categories[leftIndex]},
                ),
              ),
            ),
            12.horizontalSpace,
            if (hasRight)
              Expanded(
                child: CategoryCard(
                  title: categories[rightIndex].name,
                  imageUrl: categories[rightIndex].image,
                  onTap: () => context.push(
                    AppRoutes.category,
                    extra: {'category': categories[rightIndex]},
                  ),
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
