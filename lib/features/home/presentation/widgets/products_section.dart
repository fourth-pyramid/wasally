import 'package:wassaly/core/imports/imports.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.productsStatus != current.productsStatus ||
          previous.products != current.products,
      builder: (context, state) {
        if (state.productsStatus == HomeStatus.loading ||
            state.productsStatus == HomeStatus.initial) {
          return _buildSkeleton(context, cs, tt);
        } else if (state.productsStatus == HomeStatus.failure &&
            state.products.data.isEmpty) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        } else if (state.products.data.isEmpty &&
            state.productsStatus == HomeStatus.success) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        }

        final products = state.products.data;

        return SliverMainAxisGroup(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.home_selected_products,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Grid
            AppProductsSection(
              products: products,
              hasMore: state.products.hasMore,
              isLoadingMore: state.products.hasMore,
              onLoadMore: () {
                context.read<HomeBloc>().add(LoadMoreProductsEvent());
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSkeleton(BuildContext context, ColorScheme cs, TextTheme tt) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              context.l10n.home_selected_products,
              style: tt.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: 4.verticalSpace,
        ),
        const AppProductsSkeleton(),
      ],
    );
  }
}
