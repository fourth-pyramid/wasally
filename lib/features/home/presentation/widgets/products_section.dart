import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/home/presentation/bloc/home_bloc.dart';
import 'package:wassaly/features/home/presentation/bloc/home_event.dart';
import 'package:wassaly/features/home/presentation/bloc/home_state.dart';

final _activeMarqueeId = ValueNotifier<int?>(null);

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
            AppUnifiedSection<ProductEntity>(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              mainAxisExtent: 230.h,
              isLoading: isLoading,
              items: productsList,
              dummyItems: const [
                ProductEntity(
                  id: 1,
                  name: 'منتج تجريبي',
                  image: '',
                  price: '100',
                  description: 'وصف تجريبي',
                  offers: [],
                  reviews: [],
                  isFavorite: false,
                ),
                ProductEntity(
                  id: 2,
                  name: 'منتج تجريبي',
                  image: '',
                  price: '100',
                  description: 'وصف تجريبي',
                  offers: [],
                  reviews: [],
                  isFavorite: false,
                ),
              ],
              hasMore: products.hasMore,
              isLoadingMore: isProductsLoadingMore,
              onLoadMore: () {
                context.read<HomeBloc>().add(LoadMoreProductsEvent());
              },
              itemBuilder: (context, product, index, wrapAnimation) =>
                  wrapAnimation(
                AppUnifiedCard(
                  id: product.id,
                  title: product.name,
                  description: product.description,
                  image: product.image,
                  price: product.discountedPrice.toStringAsFixed(0),
                  originalPrice: product.hasOffer
                      ? (double.tryParse(product.price) ?? 0).toStringAsFixed(0)
                      : null,
                  discountPercentage:
                      product.hasOffer ? product.discountPercentage : null,
                  rating: product.averageRating,
                  reviewCount: product.reviewCount,
                  isFavorite: product.isFavorite,
                  activeIdNotifier: _activeMarqueeId,
                  onTap: () => context.push(
                    AppRoutes.productDetails,
                    extra: {'productId': product.id},
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
