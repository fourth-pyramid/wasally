import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/presentation/widgets/booking_card.dart';

import '../bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../bloc/orders_state.dart';
import '../widgets/order_card.dart';

class OrdersPage extends StatelessWidget {
  final int initialIndex;

  const OrdersPage({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<OrdersBloc>()
        ..add(const GetOrdersEvent())
        ..add(const GetServiceBookingsEvent()),
      child: _OrdersView(initialIndex: initialIndex),
    );
  }
}

class _OrdersView extends StatelessWidget {
  final int initialIndex;

  const _OrdersView({this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex,
      child: Scaffold(
        appBar: AppTopBar(
          title: context.l10n.profile_my_orders,
          bottom: TabBar(
            labelColor: cs.primary,
            unselectedLabelColor: cs.onSurfaceVariant,
            indicatorColor: cs.primary,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: context.l10n.order_products),
              Tab(text: context.l10n.order_services),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ProductOrdersTab(),
            _ServiceBookingsTab(),
          ],
        ),
      ),
    );
  }
}

class _ProductOrdersTab extends StatefulWidget {
  const _ProductOrdersTab();

  @override
  State<_ProductOrdersTab> createState() => _ProductOrdersTabState();
}

class _ProductOrdersTabState extends State<_ProductOrdersTab> {
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

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state.status == OrdersStatus.loading && state.orders.data.isEmpty) {
          return const Center(child: AppLoading());
        }

        if (state.status == OrdersStatus.failure && state.orders.data.isEmpty) {
          return Center(
            child: AppErrorWidget(
              title: context.l10n.errors_error_occurred_title,
              message: state.errorMessage.isNotEmpty
                  ? state.errorMessage
                  : context.l10n.errors_error_occurred_message,
              onRetry: () =>
                  context.read<OrdersBloc>().add(const GetOrdersEvent()),
            ),
          );
        }

        if (state.orders.data.isEmpty) {
          return AppEmptyState(
            title: context.l10n.order_no_orders_title,
            subtitle: context.l10n.order_no_orders_msg,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<OrdersBloc>().add(const GetOrdersEvent());
          },
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(16.r),
            itemCount: state.orders.hasMore
                ? state.orders.data.length + 1
                : state.orders.data.length,
            itemBuilder: (context, index) {
              if (index >= state.orders.data.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: AppLoading(),
                  ),
                );
              }

              final order = state.orders.data[index];
              return OrderCard(order: order);
            },
          ),
        );
      },
    );
  }
}

class _ServiceBookingsTab extends StatelessWidget {
  const _ServiceBookingsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state.serviceStatus == OrdersStatus.loading &&
            state.serviceBookings.data.isEmpty) {
          return const Center(child: AppLoading());
        }

        if (state.serviceStatus == OrdersStatus.failure &&
            state.serviceBookings.data.isEmpty) {
          return Center(
            child: AppErrorWidget(
              title: context.l10n.errors_error_occurred_title,
              message: state.errorMessage.isNotEmpty
                  ? state.errorMessage
                  : context.l10n.errors_error_occurred_message,
              onRetry: () => context
                  .read<OrdersBloc>()
                  .add(const GetServiceBookingsEvent()),
            ),
          );
        }

        if (state.serviceBookings.data.isEmpty) {
          return AppEmptyState(
            title: context.l10n.order_no_orders_title,
            subtitle: context.l10n.order_no_orders_msg,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<OrdersBloc>().add(const GetServiceBookingsEvent());
          },
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
            itemCount: state.serviceBookings.data.length,
            itemBuilder: (context, index) {
              final booking = state.serviceBookings.data[index];
              return BookingCard(booking: booking);
            },
          ),
        );
      },
    );
  }
}
