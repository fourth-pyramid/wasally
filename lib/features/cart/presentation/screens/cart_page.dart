import 'package:wassaly/core/imports/imports.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'cart.cart_title'.tr(),
          style: context.typography.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80.r,
              color: context.theme.colorScheme.primary,
            ),
            20.verticalSpace,
            Text(
              'cart.cart_title'.tr(),
              style: context.typography.headlineMedium,
            ),
            10.verticalSpace,
            Text(
              'cart.cart_subtitle'.tr(),
              style: context.typography.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
