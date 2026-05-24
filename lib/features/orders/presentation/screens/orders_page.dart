import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_event.dart';
import 'package:wassaly/features/orders/presentation/widgets/orders/product_orders_tab.dart';
import 'package:wassaly/features/orders/presentation/widgets/orders/service_bookings_tab.dart';

class OrdersPage extends StatefulWidget {
  final int initialIndex;

  const OrdersPage({super.key, this.initialIndex = 0});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with TickerProviderStateMixin {
  late final OrdersBloc _ordersBloc;
  late final TabController _tabController;
  StreamSubscription<void>? _connectivitySub;

  @override
  void initState() {
    super.initState();
    _ordersBloc = sl<OrdersBloc>();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ordersBloc.add(const GetOrdersEvent());
      _ordersBloc.add(const GetServiceBookingsEvent());
    });

    _connectivitySub =
        sl<InternetConnectionService>().connectivityRestoredStream.listen((_) {
      if (mounted) {
        _ordersBloc.add(const GetOrdersEvent());
        _ordersBloc.add(const GetServiceBookingsEvent());
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _connectivitySub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _ordersBloc,
      child: _OrdersView(tabController: _tabController),
    );
  }
}

class _OrdersView extends StatelessWidget {
  final TabController tabController;

  const _OrdersView({required this.tabController});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: AppSliverTopBar(
                title: context.l10n.profile_my_orders,
                centerTitle: true,
                pinned: true,
                floating: true,
                snap: true,
                bottom: TabBar(
                  controller: tabController,
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
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: const [
            ProductOrdersTab(),
            ServiceBookingsTab(),
          ],
        ),
      ),
    );
  }
}
