import 'package:showcase_tutorial/showcase_tutorial.dart';
import 'package:wassaly/core/constants/showcase_keys.dart';
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
      _ordersBloc
        ..add(const GetOrdersEvent())
        ..add(const GetServiceBookingsEvent());
    });

    _connectivitySub = sl<InternetConnectionService>().connectivityRestoredStream.listen((_) {
      if (mounted) {
        _ordersBloc
          ..add(const GetOrdersEvent())
          ..add(const GetServiceBookingsEvent());
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    unawaited(_connectivitySub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: _ordersBloc,
        child: ShowCaseWidget(
          showcaseId: 'orders_v1',
          enableAutoScroll: true,
          disableBarrierInteraction: true,
          onShouldStartShowcase: (id) async => !StorageService.instance.hasSeenShowcase(id!),
          onFinish: () {
            // ponytail: Persist orders tour completion
            unawaited(StorageService.instance.setHasSeenShowcase('orders_v1', value: true));
          },
          builder: Builder(
            builder: (context) => _OrdersView(tabController: _tabController),
          ),
        ),
      );
}

class _OrdersView extends StatefulWidget {
  final TabController tabController;

  const _OrdersView({required this.tabController});

  @override
  State<_OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<_OrdersView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ponytail: Trigger orders page showcase using inner context
      if (mounted) {
        ShowCaseWidget.of(context).startShowCase([
          AppShowcaseKeys.ordersTabs,
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: AppSliverTopBar(
              title: context.l10n.profile_my_orders,
              pinned: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: AppShowcase(
                  showcaseKey: AppShowcaseKeys.ordersTabs,
                  title: context.l10n.showcase_orders_tabs_title,
                  description: context.l10n.showcase_orders_tabs_desc,
                  isLast: true,
                  child: TabBar(
                    controller: widget.tabController,
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
            ),
          ),
        ],
        body: TabBarView(
          controller: widget.tabController,
          children: const [
            ProductOrdersTab(),
            ServiceBookingsTab(),
          ],
        ),
      ),
    );
  }
}
