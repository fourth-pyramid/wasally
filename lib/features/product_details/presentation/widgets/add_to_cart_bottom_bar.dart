import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_event.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_state.dart';

class AddToCartBottomBar extends StatefulWidget {
  final int productId;
  final double price;

  const AddToCartBottomBar({
    required this.productId, required this.price, super.key,
  });

  @override
  State<AddToCartBottomBar> createState() => _AddToCartBottomBarState();
}

class _AddToCartBottomBarState extends State<AddToCartBottomBar> {
  final ValueNotifier<int> _quantityNotifier = ValueNotifier(1);

  @override
  void dispose() {
    _quantityNotifier.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if product is already in cart
    context.read<CartBloc>().add(CheckIfInCartEvent(widget.productId));
  }

  void _increment() => _quantityNotifier.value++;
  void _decrement() {
    if (_quantityNotifier.value > 1) {
      _quantityNotifier.value--;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Quantity Selector
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ValueListenableBuilder<int>(
                valueListenable: _quantityNotifier,
                builder: (context, quantity, child) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onTap: _decrement,
                      color: cs,
                    ),
                    12.horizontalSpace,
                    Text(
                      '$quantity',
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                    12.horizontalSpace,
                    _QuantityButton(
                      icon: Icons.add,
                      onTap: _increment,
                      color: cs,
                    ),
                  ],
                ),
              ),
            ),
            12.horizontalSpace,
            // Add to Cart Button
            Expanded(
              child: ValueListenableBuilder<int>(
                valueListenable: _quantityNotifier,
                builder: (context, quantity, child) {
                  final price = widget.price * quantity;
                  return BlocConsumer<CartBloc, CartState>(
                    listenWhen: (prev, curr) {
                      final wasInCart = prev.isInCart(widget.productId);
                      final nowInCart = curr.isInCart(widget.productId);
                      return wasInCart != nowInCart;
                    },
                    listener: (context, state) {
                      if (state.isInCart(widget.productId)) {
                        context.showTypedSnackBar(
                          context.l10n.cart_added_to_cart,
                          type: SnackBarType.success,
                        );
                      }
                    },
                    buildWhen: (prev, curr) =>
                        prev.inCartProductIds != curr.inCartProductIds ||
                        prev.addingProductIds != curr.addingProductIds,
                    builder: (context, state) {
                      final isInCart = state.isInCart(widget.productId);
                      final isAdding = state.isAdding(widget.productId);

                      return AppShowcase(
                        showcaseKey: AppShowcaseKeys.productAddToCart,
                        title: context.l10n.showcase_product_details_add_to_cart_title,
                        description: context.l10n.showcase_product_details_add_to_cart_desc,
                        isLast: true,
                        child: AppButton(
                          label: isInCart
                              ? context.l10n.cart_already_added
                              : context.l10n.cart_add_to_cart,
                          onPressed: (isAdding || isInCart)
                              ? null
                              : () {
                                  // Add to cart only - cannot remove from here
                                  context.read<CartBloc>().add(
                                        AddToCartEvent(
                                          widget.productId,
                                          quantity: quantity,
                                        ),
                                      );
                                },
                          isLoading: isAdding,
                          isFullWidth: true,
                          prefixIcon: Icon(
                            isInCart
                                ? Icons.check_circle_outline
                                : Icons.shopping_cart_outlined,
                            size: 20.r,
                          ),
                          suffixIcon: !isInCart && !isAdding
                              ? Text(
                                  '• ${price.toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
                                  style: tt.bodySmall?.copyWith(
                                    color: cs.onPrimary,
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme color;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28.w,
          height: 28.h,
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Icon(
            icon,
            size: 16.r,
            color: color.primary,
          ),
        ),
      );
}
