import 'package:showcase_tutorial/showcase_tutorial.dart';
import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/cart/domain/entities/cart_item_entity.dart';
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
    _connectivitySub = sl<InternetConnectionService>().connectivityRestoredStream.listen((_) {
      if (mounted) _onRetryLoad(context);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cartBloc = context.read<CartBloc>();
        if (cartBloc.state.items.isNotEmpty) {
          ShowCaseWidget.of(context).startShowCase([
            AppShowcaseKeys.cartItemSwipe,
            AppShowcaseKeys.cartOrderSummary,
          ]);
        }
      }
    });
  }

  @override
  void dispose() {
    unawaited(_connectivitySub?.cancel());
    super.dispose();
  }

  // FIX 10: named methods — no new lambdas in build()
  void _onRetryLoad(BuildContext context) => context.read<CartBloc>().add(const LoadCartItemsEvent());

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: BlocListener<CartBloc, CartState>(
        listenWhen: (prev, curr) => prev.items.isEmpty && curr.items.isNotEmpty,
        listener: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ShowCaseWidget.of(context).startShowCase([
                AppShowcaseKeys.cartItemSwipe,
                AppShowcaseKeys.cartOrderSummary,
              ]);
            }
          });
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ─── AppBar (static — outside BlocBuilder) ─────────────────────────
            AppSliverTopBar(
              automaticallyImplyLeading: false,
              title: context.l10n.cart_cart_title,
            ),

            // ─── Dynamic content ( granular selectors for sub-components) ──────
            // 1. Loading State
            BlocSelector<CartBloc, CartState, bool>(
              selector: (state) => state.isLoading && state.items.isEmpty,
              builder: (context, isLoading) {
                if (!isLoading) return const SliverToBoxAdapter();
                return const SliverFillRemaining(
                  child: Center(child: AppLoading()),
                );
              },
            ),

            // 2. Error State
            BlocSelector<CartBloc, CartState, (bool, Failure?, String)>(
              selector: (state) => (state.isError && state.items.isEmpty, state.failure, state.errorMessage),
              builder: (context, data) {
                final (isError, failure, errorMessage) = data;
                if (!isError) return const SliverToBoxAdapter();

                return SliverFillRemaining(
                  child: Center(
                    child: failure != null
                        ? AppErrorWidget.failure(
                            failure: failure,
                            onRetry: () => _onRetryLoad(context),
                          )
                        : AppErrorWidget(
                            title: context.l10n.errors_error_occurred_title,
                            message:
                                errorMessage.isNotEmpty ? errorMessage : context.l10n.errors_error_occurred_message,
                            onRetry: () => _onRetryLoad(context),
                          ),
                  ),
                );
              },
            ),

            // 3. Empty State
            BlocSelector<CartBloc, CartState, bool>(
              selector: (state) => !state.isLoading && !state.isError && state.items.isEmpty,
              builder: (context, isEmpty) {
                if (!isEmpty) return const SliverToBoxAdapter();
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    icon: Icons.shopping_basket_outlined,
                    title: context.l10n.cart_empty_title,
                    subtitle: context.l10n.cart_empty_subtitle,
                  ),
                );
              },
            ),

            // 4. Cart Items List
            BlocSelector<CartBloc, CartState, List<CartItemEntity>>(
              selector: (state) => state.items,
              builder: (context, items) {
                if (items.isEmpty) return const SliverToBoxAdapter();

                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = items[index];
                        final cartItemWidget = CartItemWidget(
                          item: item,
                          onTap: () => unawaited(
                            context.push(
                              AppRoutes.productDetails,
                              extra: {'productId': item.productId},
                            ),
                          ),
                          onRemove: () => context.read<CartBloc>().add(RemoveFromCartEvent(item.id)),
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
                              context.read<CartBloc>().add(RemoveFromCartEvent(item.id));
                            }
                          },
                        );

                        if (index == 0) {
                          return AppShowcase(
                            showcaseKey: AppShowcaseKeys.cartItemSwipe,
                            title: context.l10n.showcase_cart_swipe_title,
                            description: context.l10n.showcase_cart_swipe_desc,
                            child: cartItemWidget,
                          );
                        }
                        return cartItemWidget;
                      },
                      childCount: items.length,
                    ),
                  ),
                );
              },
            ),

            // 5. Order Summary
            BlocSelector<CartBloc, CartState, bool>(
              selector: (state) => state.items.isNotEmpty,
              builder: (context, hasItems) {
                if (!hasItems) return const SliverToBoxAdapter();

                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
                    child: AppShowcase(
                      showcaseKey: AppShowcaseKeys.cartOrderSummary,
                      title: context.l10n.showcase_cart_summary_title,
                      description: context.l10n.showcase_cart_summary_desc,
                      isLast: true,
                      child: BlocBuilder<CartBloc, CartState>(
                        buildWhen: (prev, curr) => prev.items != curr.items || prev.checkoutData != curr.checkoutData,
                        builder: (context, state) => CartOrderSummary(state: state),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
