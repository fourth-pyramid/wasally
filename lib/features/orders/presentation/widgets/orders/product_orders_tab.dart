import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/domain/entities/order_entity.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_event.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_state.dart';
import 'package:wassaly/features/orders/presentation/widgets/orders/order_card.dart';

class ProductOrdersTab extends StatefulWidget {
  const ProductOrdersTab({super.key});

  @override
  State<ProductOrdersTab> createState() => _ProductOrdersTabState();
}

class _ProductOrdersTabState extends State<ProductOrdersTab> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<OrdersBloc>().add(const LoadMoreOrdersEvent());
    }
  }

  void _onRetry() {
    context.read<OrdersBloc>().add(const GetOrdersEvent());
  }

  Future<void> _onRefresh() async {
    context.read<OrdersBloc>().add(const GetOrdersEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OrdersBloc, OrdersState,
        (OrdersStatus, PaginatedResponse<OrderEntity>, String)>(
      selector: (state) => (state.status, state.orders, state.errorMessage),
      builder: (context, data) {
        final (status, orders, errorMessage) = data;

        if (status == OrdersStatus.loading && orders.data.isEmpty) {
          return const Center(child: AppLoading());
        }

        if (status == OrdersStatus.failure && orders.data.isEmpty) {
          return Center(
            child: AppErrorWidget(
              title: context.l10n.errors_error_occurred_title,
              message: errorMessage.isNotEmpty
                  ? errorMessage
                  : context.l10n.errors_error_occurred_message,
              onRetry: _onRetry,
            ),
          );
        }

        if (orders.data.isEmpty) {
          return AppEmptyState(
            title: context.l10n.order_no_product_orders_title,
            subtitle: context.l10n.order_no_product_orders_msg,
          );
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(16.r),
                sliver: SliverList.builder(
                  itemCount: orders.hasMore
                      ? orders.data.length + 1
                      : orders.data.length,
                  itemBuilder: (context, index) {
                    if (index >= orders.data.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: AppLoading(),
                        ),
                      );
                    }

                    final order = orders.data[index];
                    return OrderCard(order: order);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
