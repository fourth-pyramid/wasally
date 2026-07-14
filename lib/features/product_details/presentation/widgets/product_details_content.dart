import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/product_details/domain/entities/product_detail_entity.dart';
import 'package:wassaly/features/product_details/presentation/bloc/product_details_state.dart';
import 'package:wassaly/features/product_details/presentation/widgets/add_to_cart_bottom_bar.dart';
import 'package:wassaly/features/product_details/presentation/widgets/product_details_gallery.dart';
import 'package:wassaly/features/product_details/presentation/widgets/product_details_info.dart';

class ProductDetailsContent extends StatelessWidget {
  final ProductDetailEntity product;
  final RelatedProductsStatus relatedProductsStatus;
  final List<ProductEntity> relatedProducts;

  const ProductDetailsContent({
    required this.product, required this.relatedProductsStatus, required this.relatedProducts, super.key,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        ShowCaseWidget.of(context).startShowCase([
          AppShowcaseKeys.productAddToCart,
        ]);
      }
    });

    final gallery = _resolveGallery(product);

    final price = double.tryParse(product.price) ?? 0;
    final finalPrice = product.hasOffer ? product.discountedPrice : price;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AppSliverTopBar(
            title: context.l10n.product_details_title,
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
