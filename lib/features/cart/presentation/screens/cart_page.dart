import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_event.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_state.dart';
import 'package:wassaly/features/cart/presentation/widgets/cart/cart_item_widget.dart';
import 'package:wassaly/features/cart/presentation/widgets/cart/cart_order_summary.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  StreamSubscription<void>? _connectivitySub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartBloc = context.read<CartBloc>();
      // Only load if never fetched before (initial state).
      // Avoid reloading when the cart was already fetched but is empty.
      if (cartBloc.state.status == CartStatus.initial) {
        cartBloc.add(const LoadCartItemsEvent());
      }
    });
    _connectivitySub = sl<InternetConnectionService>()
        .connectivityRestoredStream
        .listen((_) {
      if (mounted) _onRetryLoad(context);
    });
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }

  // FIX 10: named methods — no new lambdas in build()
  void _onRetryLoad(BuildContext context) =>
      context.read<CartBloc>().add(const LoadCartItemsEvent());

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    // FIX 4: Scaffold + CustomScrollView + AppSliverTopBar are OUTSIDE BlocBuilder
    // — they never change with cart state
    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ─── AppBar (static — outside BlocBuilder) ─────────────────────────
          AppSliverTopBar(
            automaticallyImplyLeading: false,
            title: context.l10n.cart_cart_title,
          ),

          // ─── Dynamic content (only what changes with state) ─────────────────
          BlocBuilder<CartBloc, CartState>(
            // Only rebuild when visible content changes.
            // Ignoring addingProductIds / inCartProductIds changes prevents
            // flutter_animate from restarting animations mid-frame.
            buildWhen: (prev, curr) =>
                prev.status != curr.status ||
                prev.items != curr.items ||
                prev.failure != curr.failure,
            builder: (context, state) {
              if (state.isLoading && state.items.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: AppLoading()),
                );
              }
              if (state.isError && state.items.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: state.failure != null
                        ? AppErrorWidget.failure(
                            failure: state.failure!,
                            onRetry: () => _onRetryLoad(context), // FIX 10
                          )
                        : AppErrorWidget(
                            title: context.l10n.errors_error_occurred_title,
                            message: state.errorMessage.isNotEmpty
                                ? state.errorMessage
                                : context.l10n.errors_error_occurred_message,
                            onRetry: () => _onRetryLoad(context), // FIX 10
                          ),
                  ),
                );
              }
              if (state.items.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    icon: Icons.shopping_basket_outlined,
                    title: context.l10n.cart_empty_title,
                    subtitle: context.l10n.cart_empty_subtitle,
                  ),
                );
              }
              return SliverMainAxisGroup(
                slivers: [
                  // Cart Items List
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 16.h),
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
                                context
                                    .read<CartBloc>()
                                    .add(RemoveFromCartEvent(item.id));
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
                      child: CartOrderSummary(state: state),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
