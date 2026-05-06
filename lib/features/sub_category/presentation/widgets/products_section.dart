import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

import '../bloc/sub_category_bloc.dart';
import '../bloc/sub_category_event.dart';

class ProductsSection extends StatelessWidget {
  final List<ProductEntity> products;
  final bool hasMore;
  final bool isLoadingMore;
  final int subCategoryId;

  const ProductsSection({
    super.key,
    required this.products,
    required this.hasMore,
    required this.isLoadingMore,
    required this.subCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverProductGrid<ProductEntity>(
          items: products,
          hasMore: hasMore && !isLoadingMore,
          onLoadMore: () {
            context.read<SubCategoryBloc>().add(
                  LoadMoreProductsEvent(subCategoryId),
                );
          },
          itemBuilder: (context, product, index, wrapAnimation) {
            return wrapAnimation(
              ProductCard(
                product: product,
                onTap: () {
                  // TODO: Navigate to product detail
                },
                onOpenProductTap: () {},
              ),
            );
          },
        ),
        if (isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: SizedBox(height: 20.h),
        ),
      ],
    );
  }
}
