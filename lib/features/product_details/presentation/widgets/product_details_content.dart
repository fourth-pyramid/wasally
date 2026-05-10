import 'package:wassaly/core/imports/imports.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../domain/entities/product_detail_entity.dart';
import '../bloc/product_details_state.dart';
import 'add_to_cart_bottom_bar.dart';
import 'product_details_gallery.dart';
import 'product_details_info.dart';

class ProductDetailsContent extends StatelessWidget {
  final ProductDetailEntity product;
  final RelatedProductsStatus relatedProductsStatus;
  final List<ProductEntity> relatedProducts;

  const ProductDetailsContent({
    super.key,
    required this.product,
    required this.relatedProductsStatus,
    required this.relatedProducts,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final gallery = _resolveGallery(product);

    final price = double.tryParse(product.price) ?? 0;
    final finalPrice = product.hasOffer ? product.discountedPrice : price;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: cs.surface,
            foregroundColor: cs.primary,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'product_details.title'.tr(),
              style: tt.titleLarge?.copyWith(
                color: cs.primary,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductDetailsGallery(gallery: gallery),
                16.verticalSpace,
                ProductDetailsInfo(
                  product: product,
                  relatedProductsStatus: relatedProductsStatus,
                  relatedProducts: relatedProducts,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AddToCartBottomBar(
        productId: product.id,
        price: finalPrice,
      ),
    );
  }

  List<String> _resolveGallery(ProductDetailEntity product) {
    final images =
        product.images.map((e) => e.image).where((e) => e.isNotEmpty).toList();
    if (product.image.isNotEmpty && !images.contains(product.image)) {
      images.insert(0, product.image);
    }
    return images.isEmpty ? <String>[product.image] : images;
  }
}
