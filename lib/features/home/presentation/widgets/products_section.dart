import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/offer_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/review_entity.dart';
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
          return _buildSkeleton(cs, tt);
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
                      'home.selected_products'.tr(),
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
            SliverProductGrid<ProductEntity>(
              items: products,
              hasMore: state.products.hasMore,
              onLoadMore: () {
                context.read<HomeBloc>().add(LoadMoreProductsEvent());
              },
              itemBuilder: (context, product, index, wrapAnimation) {
                return wrapAnimation(
                  ProductCard(
                    product: product,
                    onTap: () {
                      // TODO: Navigate to product details
                    },
                    onOpenProductTap: () {
                      // TODO: open product
                    },
                  ),
                );
              },
            ),

            // Load more indicator
            if (state.products.hasMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSkeleton(ColorScheme cs, TextTheme tt) {
    final dummyProducts = List.generate(
      4,
      (index) => const ProductEntity(
        id: 0,
        name: 'منتج تجريبي',
        image: '',
        price: '100',
        description: 'وصف تجريبي',
        offers: [OfferEntity(id: 0, discountPercentage: 10)],
        reviews: [
          ReviewEntity(id: 0, rating: 5, comment: 'ممتاز', createdAt: ''),
        ],
        isFavorite: false,
      ),
    );

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              'home.selected_products'.tr(),
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
        SliverProductGrid<ProductEntity>(
          items: dummyProducts,
          animateItems: false,
          itemBuilder: (context, product, index, wrapAnimation) {
            return Skeletonizer(
              ignoreContainers: true,
              enabled: true,
              child: ProductCard(product: product),
            );
          },
        ),
      ],
    );
  }
}
