import 'package:wassaly/core/imports/imports.dart';

import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';

class AddToCartBottomBar extends StatefulWidget {
  final int productId;
  final double price;

  const AddToCartBottomBar({
    super.key,
    required this.productId,
    required this.price,
  });

  @override
  State<AddToCartBottomBar> createState() => _AddToCartBottomBarState();
}

class _AddToCartBottomBarState extends State<AddToCartBottomBar> {
  int _quantity = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if product is already in cart
    context.read<CartBloc>().add(CheckIfInCartEvent(widget.productId));
  }

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final price = widget.price * _quantity;

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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _QuantityButton(
                    icon: Icons.remove,
                    onTap: _decrement,
                    color: cs,
                  ),
                  12.horizontalSpace,
                  Text(
                    '$_quantity',
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
            12.horizontalSpace,
            // Add to Cart Button
            Expanded(
              child: BlocConsumer<CartBloc, CartState>(
                listenWhen: (prev, curr) {
                  final wasInCart = prev.isInCart(widget.productId);
                  final nowInCart = curr.isInCart(widget.productId);
                  return wasInCart != nowInCart;
                },
                listener: (context, state) {
                  if (state.isInCart(widget.productId)) {
                    context.showTypedSnackBar('تم إضافة المنتج للسلة',
                        type: SnackBarType.success);
                  }
                },
                buildWhen: (prev, curr) =>
                    prev.inCartProductIds != curr.inCartProductIds ||
                    prev.addingProductIds != curr.addingProductIds,
                builder: (context, state) {
                  final isInCart = state.isInCart(widget.productId);
                  final isAdding = state.isAdding(widget.productId);

                  return AppButton(
                    label: isInCart ? 'تم الإضافة' : 'أضف للسلة',
                    onPressed: (isAdding || isInCart)
                        ? null
                        : () {
                            // Add to cart only - cannot remove from here
                            context.read<CartBloc>().add(
                                  AddToCartEvent(
                                    widget.productId,
                                    quantity: _quantity,
                                  ),
                                );
                          },
                    variant: ButtonVariant.primary,
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
                            '• ${price.toStringAsFixed(0)} ${'shared.currency_egp'.tr()}',
                            style: tt.bodySmall?.copyWith(
                              color: cs.onPrimary,
                            ),
                          )
                        : null,
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
  Widget build(BuildContext context) {
    return GestureDetector(
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
}
