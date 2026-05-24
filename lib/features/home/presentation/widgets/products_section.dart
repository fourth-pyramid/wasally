import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/home/presentation/bloc/home_bloc.dart';
import 'package:wassaly/features/home/presentation/bloc/home_event.dart';
import 'package:wassaly/features/home/presentation/bloc/home_state.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocSelector<HomeBloc, HomeState,
        (HomeStatus, PaginatedResponse<ProductEntity>, bool)>(
      selector: (state) =>
          (state.productsStatus, state.products, state.isProductsLoadingMore),
      builder: (context, data) {
        final (productsStatus, products, isProductsLoadingMore) = data;

        final isLoading = productsStatus == HomeStatus.loading ||
            productsStatus == HomeStatus.initial;

        if (productsStatus == HomeStatus.failure && products.data.isEmpty) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        } else if (products.data.isEmpty &&
            productsStatus == HomeStatus.success) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        }

        final productsList = products.data;

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
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              mainAxisExtent: 230.h,
              isLoading: isLoading,
              products: productsList,
              hasMore: products.hasMore,
              isLoadingMore: isProductsLoadingMore,
              onLoadMore: () {
                context.read<HomeBloc>().add(LoadMoreProductsEvent());
              },
            ),
          ],
        );
      },
    );
  }
}
