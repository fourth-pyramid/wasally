import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_event.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_state.dart';
import 'package:wassaly/features/cart/presentation/widgets/cart_item_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartBloc = context.read<CartBloc>();
      final state = cartBloc.state;

      // Load cart items if needed
      if (state.items.isEmpty && !state.isLoading) {
        cartBloc.add(const LoadCartItemsEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ─── AppBar ────────────────────────────────────────────────────────────
              AppSliverTopBar(
                title: context.l10n.cart_cart_title,
              ),

              // ─── Content ───────────────────────────────────────────────────────────
              if (state.isLoading && state.items.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: AppLoading()),
                )
              else if (state.isError && state.items.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: state.failure != null
                        ? AppErrorWidget.failure(
                            failure: state.failure!,
                            onRetry: () => context
                                .read<CartBloc>()
                                .add(const LoadCartItemsEvent()),
                          )
                        : AppErrorWidget(
                            title: context.l10n.errors_error_occurred_title,
                            message: state.errorMessage.isNotEmpty
                                ? state.errorMessage
                                : context.l10n.errors_error_occurred_message,
                            onRetry: () => context
                                .read<CartBloc>()
                                .add(const LoadCartItemsEvent()),
                          ),
                  ),
                )
              else if (state.items.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyCart(context),
                )
              else ...[
                // Cart Items List
                SliverPadding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = state.items[index];
                        return CartItemWidget(
                          item: item,
                          onRemove: () => context
                              .read<CartBloc>()
                              .add(RemoveFromCartEvent(item.id)),
                          onQuantityIncrease: () =>
                              context.read<CartBloc>().add(
                                    UpdateQuantityEvent(
                                      cartItemId: item.id,
                                      quantity: item.quantity + 1,
                                    ),
                                  ),
                          onQuantityDecrease: () {
                            if (item.quantity > 1) {
                              context.read<CartBloc>().add(
                                    UpdateQuantityEvent(
                                      cartItemId: item.id,
                                      quantity: item.quantity - 1,
                                    ),
                                  );
                            } else {
                              context.read<CartBloc>().add(
                                    RemoveFromCartEvent(item.id),
                                  );
                            }
                          },
                        );
                      },
                      childCount: state.items.length,
                    ),
                  ),
                ),

                // Order Summary
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
                    child: _buildOrderSummary(context, state),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  // ─── Empty State ────────────────────────────────────────────────────────────

  Widget _buildEmptyCart(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with a soft background
            Container(
              padding: EdgeInsets.all(30.r),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_basket_outlined,
                size: 80.r,
                color: cs.primary.withValues(alpha: 0.4),
              ),
            )
                .animate()
                .scale(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack)
                .fadeIn(),

            32.verticalSpace,

            // Title
            Text(
              context.l10n.cart_empty_title,
              style: tt.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: cs.onSurface,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .slideY(begin: 0.2, duration: const Duration(milliseconds: 400))
                .fadeIn(),

            12.verticalSpace,

            // Subtitle
            Text(
              context.l10n.cart_empty_subtitle,
              style: tt.bodyLarge?.copyWith(
                color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .slideY(
                    begin: 0.3,
                    delay: const Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 400))
                .fadeIn(),
          ],
        ),
      ),
    );
  }

  // ─── Order Summary ───────────────────────────────────────────────────────────

  Widget _buildOrderSummary(BuildContext context, CartState state) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final totalOriginalPrice = state.items.fold<double>(
      0,
      (sum, item) => sum + (double.tryParse(item.price) ?? 0.0) * item.quantity,
    );

    final totalAfterProductOffers = state.items.fold<double>(
      0,
      (sum, item) {
        final originalPrice = double.tryParse(item.price) ?? 0.0;
        final hasOffer = item.offers != null && item.offers!.isNotEmpty;
        final discountedPrice = hasOffer
            ? originalPrice *
                (1 - (item.offers!.first.discountPercentage / 100))
            : originalPrice;
        return sum + (discountedPrice * item.quantity);
      },
    );

    final productOffersDiscount = totalOriginalPrice - totalAfterProductOffers;

    final total = totalAfterProductOffers.clamp(0.0, double.infinity);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price Summary Section
          _SummaryRow(
            label: context.l10n.cart_subtotal,
            value:
                '${totalOriginalPrice.toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
          ),
          if (productOffersDiscount > 0) ...[
            8.verticalSpace,
            _SummaryRow(
              label: context.l10n.cart_product_offers,
              value:
                  '- ${productOffersDiscount.toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
              valueColor: Colors.green,
            ),
          ],
          12.verticalSpace,
          AppDivider(color: cs.outline.withValues(alpha: 0.3), height: 1),
          12.verticalSpace,
          _SummaryRow(
            label: context.l10n.cart_total,
            value:
                '${total.toStringAsFixed(0)} ${context.l10n.shared_currency_egp}',
            isBold: true,
            valueColor: cs.primary,
          ),
          16.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.push(AppRoutes.checkout, extra: state),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                context.l10n.cart_checkout,
                style: tt.titleMedium?.copyWith(
                  color: cs.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Summary Row ─────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final style = isBold
        ? tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)
        : tt.bodyMedium?.copyWith(color: cs.onSurface.withValues(alpha: 0.6));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          value,
          style: style?.copyWith(
            color: valueColor ?? (isBold ? cs.onSurface : null),
          ),
        ),
      ],
    );
  }
}
