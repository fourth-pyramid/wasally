import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/domain/entities/order_entity.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_event.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_state.dart';
import 'package:wassaly/features/orders/presentation/widgets/orders/order_card.dart';

class ProductOrdersTab extends StatelessWidget {
  const ProductOrdersTab({super.key});

  void _onRetry(BuildContext context) {
    context.read<OrdersBloc>().add(const GetOrdersEvent());
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<OrdersBloc>().add(const GetOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocSelector<OrdersBloc, OrdersState,
        (OrdersStatus, PaginatedResponse<OrderEntity>, String)>(
      selector: (state) => (state.status, state.orders, state.errorMessage),
      builder: (context, data) {
        final (status, orders, errorMessage) = data;

        if (status == OrdersStatus.failure && orders.data.isEmpty) {
          return Center(
            child: AppErrorWidget(
              title: context.l10n.errors_error_occurred_title,
              message: errorMessage.isNotEmpty
                  ? errorMessage
                  : context.l10n.errors_error_occurred_message,
              onRetry: () => _onRetry(context),
            ),
          );
        }

        final showSkeleton =
            status == OrdersStatus.loading && orders.data.isEmpty;
        final displayOrders = showSkeleton
            ? List.generate(
                3,
                (index) => OrderEntity(
                  id: index,
                  orderNumber: '12345$index',
                  status: 'pending',
                  totalPrice: 150,
                  paymentMethod: 'cash',
                  deliveryFees: 15,
                  items: const [],
                  createdAt: DateTime.now().toIso8601String(),
                ),
              )
            : orders.data;

        return RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          color: cs.primary,
          backgroundColor: cs.surface,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              final metrics = notification.metrics;
              if (metrics.pixels >= metrics.maxScrollExtent * 0.9) {
                context.read<OrdersBloc>().add(const LoadMoreOrdersEvent());
              }
              return false;
            },
            child: Skeletonizer(
              enabled: showSkeleton,
              ignoreContainers: true,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  if (displayOrders.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: AppEmptyState(
                        title: context.l10n.order_no_product_orders_title,
                        subtitle: context.l10n.order_no_product_orders_msg,
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.all(16.r),
                      sliver: SliverList.builder(
                        itemCount: orders.hasMore && !showSkeleton
                            ? displayOrders.length + 1
                            : displayOrders.length,
                        itemBuilder: (context, index) {
                          if (index >= displayOrders.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: AppLoading(),
                              ),
                            );
                          }

                          final order = displayOrders[index];
                          return OrderCard(order: order);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
