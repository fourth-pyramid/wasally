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
      context.read<CartBloc>().add(const LoadCartItemsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        title: Text(
          'cart.cart_title'.tr(),
          style: context.typography.titleLarge,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.theme.colorScheme.surface,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.items != current.items,
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: AppLoading());
          }

          if (state.isError) {
            return Center(
              child: AppErrorWidget(
                message: state.errorMessage ?? 'cart.error_loading_cart'.tr(),
                onRetry: () =>
                    context.read<CartBloc>().add(const LoadCartItemsEvent()),
              ),
            );
          }

          if (state.items.isEmpty) {
            return _buildEmptyCart(context);
          }

          return _buildCartContent(context, state);
        },
      ),
    );
  }

  // ─── Empty State ────────────────────────────────────────────────────────────

  Widget _buildEmptyCart(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          24.verticalSpace,
          Text(
            'cart.empty_title'.tr(),
            style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          8.verticalSpace,
          Text(
            'cart.empty_subtitle'.tr(),
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          32.verticalSpace,
          FilledButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            label: Text('cart.continue_shopping'.tr()),
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Cart Content ────────────────────────────────────────────────────────────

  Widget _buildCartContent(BuildContext context, CartState state) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      itemCount: state.items.length + 1, // +1 for the summary
      itemBuilder: (context, index) {
        // If this is the last item, show the summary
        if (index == state.items.length) {
          return _buildOrderSummary(context, state);
        }

        // Otherwise show cart item
        final item = state.items[index];
        return CartItemWidget(
          item: item,
          onRemove: () =>
              context.read<CartBloc>().add(RemoveFromCartEvent(item.id)),
          onQuantityIncrease: () => context.read<CartBloc>().add(
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
    );
  }

  // ─── Order Summary ───────────────────────────────────────────────────────────

  Widget _buildOrderSummary(BuildContext context, CartState state) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final subtotal = state.items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );
    final total = subtotal;

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
        children: [
          _SummaryRow(
            label: 'cart.subtotal'.tr(),
            value:
                '${subtotal.toStringAsFixed(0)} ${'shared.currency_egp'.tr()}',
          ),
          12.verticalSpace,
          AppDivider(color: cs.outline.withValues(alpha: 0.3), height: 1),
          12.verticalSpace,
          _SummaryRow(
            label: 'cart.total'.tr(),
            value: '${total.toStringAsFixed(0)} ${'shared.currency_egp'.tr()}',
            isBold: true,
            valueColor: cs.primary,
          ),
          16.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.push(AppRoutes.checkout),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                'cart.checkout'.tr(),
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
