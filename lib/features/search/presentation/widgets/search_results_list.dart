import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/search/presentation/bloc/search_bloc.dart';
import 'package:wassaly/features/search/presentation/bloc/search_event.dart';
import 'package:wassaly/features/search/presentation/bloc/search_state.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (previous, current) =>
          previous.products != current.products ||
          previous.status != current.status,
      builder: (context, state) {
        final products = state.products.data;

        return CustomScrollView(
          slivers: [
            SliverProductGrid<ProductEntity>(
              items: products,
              hasMore: state.products.hasMore,
              onLoadMore: () {
                context.read<SearchBloc>().add(const SearchLoadMore());
              },
              padding: EdgeInsets.only(top: 8.h),
              itemBuilder: (context, product, index, wrapAnimation) {
                return wrapAnimation(
                  ProductCard(
                    product: product,
                    onTap: () {
                      // TODO: Navigate to product details
                    },
                    onFavoriteTap: () {
                      // TODO: Toggle favorite
                    },
                    onOpenProductTap: () {
                      // TODO: Open product
                    },
                  ),
                );
              },
            ),
            if (state.isLoadingMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
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
}
