import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/search/presentation/bloc/search_bloc.dart';
import 'package:wassaly/features/search/presentation/bloc/search_event.dart';
import 'package:wassaly/features/search/presentation/bloc/search_state.dart';

final _activeMarqueeId = ValueNotifier<int?>(null);

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocSelector<SearchBloc, SearchState, (List<ProductEntity>, bool, bool)>(
        selector: (state) => (
          state.products.data,
          state.products.hasMore,
          state.isLoadingMore,
        ),
        builder: (context, data) {
          final (products, hasMore, isLoadingMore) = data;

          return SliverMainAxisGroup(
            slivers: [
              AppSliverGrid<ProductEntity>(
                items: products,
                hasMore: hasMore,
                onLoadMore: () {
                  context.read<SearchBloc>().add(const SearchLoadMore());
                },
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemBuilder: (context, product, index, wrapAnimation) =>
                    wrapAnimation(
                  AppUnifiedCard(
                    id: product.id,
                    title: product.name,
                    description: product.description,
                    image: product.image,
                    price: product.discountedPrice.toStringAsFixed(0),
                    originalPrice: product.hasOffer
                        ? (double.tryParse(product.price) ?? 0)
                            .toStringAsFixed(0)
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
              if (isLoadingMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: const AppLoading(),
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(height: 24.h),
              ),
            ],
          );
        },
      );
}
