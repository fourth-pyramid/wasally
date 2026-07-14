import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/orders/domain/entities/order_entity.dart';
import 'package:wassaly/features/orders/domain/entities/order_item_entity.dart';
import 'package:wassaly/features/orders/presentation/bloc/order_detail/order_detail_bloc.dart';
import 'package:wassaly/features/orders/presentation/bloc/order_detail/order_detail_event.dart';
import 'package:wassaly/features/orders/presentation/bloc/order_detail/order_detail_state.dart';
import 'package:wassaly/features/orders/presentation/widgets/order_details/order_details_cards.dart';
import 'package:wassaly/features/orders/presentation/widgets/order_details/order_tracker_widget.dart';
import 'package:wassaly/features/orders/presentation/widgets/order_details/update_order_sheet.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;

  const OrderDetailsPage({required this.orderId, super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ShowCaseWidget(
        showcaseId: 'order_details_v1',
        enableAutoScroll: true,
        disableBarrierInteraction: true,
        onShouldStartShowcase: (id) async => !StorageService.instance.hasSeenShowcase(id!),
        onFinish: () {
          unawaited(
            StorageService.instance.setHasSeenShowcase('order_details_v1', value: true),
          );
        },
        builder: Builder(
          builder: (context) => _OrderDetailsView(
            orderId: widget.orderId,
            scrollController: _scrollController,
          ),
        ),
      );
}

class _OrderDetailsView extends StatefulWidget {
  final int orderId;
  final ScrollController scrollController;

  const _OrderDetailsView({
    required this.orderId,
    required this.scrollController,
  });

  @override
  State<_OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<_OrderDetailsView> {
  bool _isDeleting = false;
  bool _shouldRefresh = false;
  bool _allowPop = false;

  static const _dummyOrder = OrderEntity(
    id: 0,
    orderNumber: '12345678',
    status: 'pending',
    totalPrice: 150,
    paymentMethod: 'cash',
    deliveryFees: 15,
    subTotal: 135,
    discountAmount: 0,
    createdAt: '2024-01-01T00:00:00Z',
    customerName: 'اسم العميل التجريبي',
    customerPhone: '01000000000',
    deliveryAddress: 'شارع تجريبي، المنطقة التجريبية',
    governorateName: 'القاهرة',
    centerName: 'مدينة نصر',
    items: [
      OrderItemEntity(
        id: 1,
        price: 75,
        quantity: 2,
        totalPrice: 150,
        product: ProductEntity(
          id: 1,
          name: 'اسم منتج تجريبي للمعاينة',
          image: '',
          price: '75.0',
          description: 'وصف منتج تجريبي للمعاينة بالكامل وسريع',
          offers: [],
          reviews: [],
          isFavorite: false,
        ),
      ),
    ],
  );

  void _onRetry() {
    context.read<OrderDetailBloc>().add(FetchOrderDetailEvent(widget.orderId));
  }

  bool _showcaseStarted = false;

  void _maybeStartShowcase(BuildContext ctx) {
    if (_showcaseStarted) return;
    _showcaseStarted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ctx.mounted) {
        ShowCaseWidget.of(ctx).startShowCase([
          AppShowcaseKeys.orderDetailsStatus,
          AppShowcaseKeys.orderDetailsItems,
        ]);
      }
    });
  }

  Future<void> _onCancelOrder(OrderEntity order) async {
    final confirmed = await showAppDialog<bool>(
      child: Builder(
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cancel_outlined,
                  size: 48.r,
                  color: context.theme.colorScheme.error,
                ),
                16.verticalSpace,
                Text(
                  context.l10n.order_cancel_title,
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                8.verticalSpace,
                Text(
                  context.l10n.order_cancel_confirm_msg,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                24.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: context.l10n.shared_cancel,
                        variant: ButtonVariant.ghost,
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: AppButton(
                        isFullWidth: true,
                        label: context.l10n.order_details_cancel_btn,
                        variant: ButtonVariant.danger,
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!mounted) return;

    if (confirmed ?? false) {
      context.read<OrderDetailBloc>().add(CancelOrderEvent(order.id));
    }
  }

  Future<void> _onDeleteOrder(OrderEntity order) async {
    final confirmed = await showAppDialog<bool>(
      child: Builder(
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.delete_outline,
                  size: 48.r,
                  color: context.theme.colorScheme.error,
                ),
                16.verticalSpace,
                Text(
                  context.l10n.order_delete_title,
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                8.verticalSpace,
                Text(
                  context.l10n.order_delete_confirm_msg,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                24.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: context.l10n.shared_cancel,
                        variant: ButtonVariant.ghost,
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: AppButton(
                        isFullWidth: true,
                        label: context.l10n.shared_delete,
                        variant: ButtonVariant.danger,
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!mounted) return;

    if (confirmed ?? false) {
      setState(() {
        _isDeleting = true;
      });
      context.read<OrderDetailBloc>().add(DeleteOrderEvent(order.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.theme.textTheme;

    return PopScope<bool?>(
      canPop: _allowPop || !_shouldRefresh,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        setState(() {
          _allowPop = true;
        });
        context.pop(_shouldRefresh);
      },
      child: Scaffold(
        body: BlocListener<OrderDetailBloc, OrderDetailState>(
          listenWhen: (previous, current) => previous.actionStatus != current.actionStatus,
          listener: (context, state) {
            if (state.actionStatus == OrderActionStatus.success) {
              context.showTypedSnackBar(
                _isDeleting ? context.l10n.order_delete_success : context.l10n.order_details_action_success,
                type: SnackBarType.success,
              );
              if (_isDeleting) {
                context.pop(true);
              } else {
                setState(() {
                  _shouldRefresh = true;
                });
              }
            } else if (state.actionStatus == OrderActionStatus.failure) {
              setState(() {
                _isDeleting = false;
              });
              context.showTypedSnackBar(
                state.actionErrorMessage,
                type: SnackBarType.error,
              );
            }
          },
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<OrderDetailBloc>().add(FetchOrderDetailEvent(widget.orderId));
            },
            color: context.theme.colorScheme.primary,
            backgroundColor: context.theme.colorScheme.surface,
            child: BlocSelector<OrderDetailBloc, OrderDetailState, (OrderDetailStatus, OrderEntity?, String, bool)>(
              selector: (state) => (
                state.status,
                state.order,
                state.errorMessage,
                state.isNotFound,
              ),
              builder: (context, data) {
                final (status, stateOrder, errorMessage, isNotFound) = data;

                if (status == OrderDetailStatus.failure && stateOrder == null) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      AppSliverTopBar(
                        title: context.l10n.order_details_title,
                        onPressed: () => context.pop(_shouldRefresh),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: isNotFound
                              ? _buildNotFoundState(context)
                              : AppErrorWidget(
                                  title: context.l10n.errors_error_occurred_title,
                                  message: errorMessage.isNotEmpty
                                      ? errorMessage
                                      : context.l10n.errors_error_occurred_message,
                                  onRetry: _onRetry,
                                ),
                        ),
                      ),
                    ],
                  );
                }

                final showSkeleton = status == OrderDetailStatus.loading && stateOrder == null;
                final order = showSkeleton ? _dummyOrder : stateOrder;

                if (order == null) {
                  return CustomScrollView(
                    controller: widget.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      AppSliverTopBar(
                        title: context.l10n.order_details_title,
                        onPressed: () => context.pop(_shouldRefresh),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            context.l10n.errors_something_went_wrong,
                            style: tt.bodyLarge,
                          ),
                        ),
                      ),
                    ],
                  );
                }

                final isCancelled = order.isCancelled;
                final canDelete = order.canDelete;
                final canCancelOrUpdate = order.canCancelOrUpdate;

                if (!showSkeleton) _maybeStartShowcase(context);

                return Skeletonizer(
                  enabled: showSkeleton,
                  ignoreContainers: true,
                  child: CustomScrollView(
                    controller: widget.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      AppSliverTopBar(
                        title: context.l10n.order_details_title,
                        onPressed: () => context.pop(_shouldRefresh),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            // 1. Order Status Summary Header
                            AppShowcase(
                              showcaseKey: AppShowcaseKeys.orderDetailsStatus,
                              title: context.l10n.showcase_order_details_status_title,
                              description: context.l10n.showcase_order_details_status_desc,
                              child: OrderHeaderCard(
                                order: order,
                                isCancelled: isCancelled,
                              ),
                            ),
                            16.verticalSpace,

                            // 2. Beautiful Cancellation Alert if cancelled
                            if (isCancelled) ...[
                              const OrderCancelledAlert(),
                              16.verticalSpace,
                            ],

                            // 3. Gorgeous Interactive Status Timeline Card
                            _buildSectionHeader(
                              context,
                              context.l10n.order_details_status,
                            ),
                            8.verticalSpace,
                            AppCard(
                              showShadow: true,
                              padding: EdgeInsets.all(16.r),
                              child: OrderTrackerWidget(status: order.status),
                            ),
                            16.verticalSpace,

                            // 4. Delivery & Customer Address Card
                            _buildSectionHeader(
                              context,
                              context.l10n.order_details_delivery_info,
                            ),
                            8.verticalSpace,
                            OrderDeliveryInfoCard(order: order),
                            16.verticalSpace,

                            // 5. Order Items / Products Card
                            _buildSectionHeader(
                              context,
                              context.l10n.order_details_ordered_products,
                            ),
                            8.verticalSpace,
                            AppShowcase(
                              showcaseKey: AppShowcaseKeys.orderDetailsItems,
                              title: context.l10n.showcase_order_details_items_title,
                              description: context.l10n.showcase_order_details_items_desc,
                              isLast: true,
                              child: OrderItemsCard(items: order.items),
                            ),
                            16.verticalSpace,

                            // 6. Detailed Receipt/Payment Card
                            _buildSectionHeader(
                              context,
                              context.l10n.order_details_payment_summary,
                            ),
                            8.verticalSpace,
                            OrderReceiptSummaryCard(order: order),
                            24.verticalSpace,

                            // 7. Action Buttons
                            if (!showSkeleton && (canDelete || canCancelOrUpdate)) ...[
                              _buildSectionHeader(
                                context,
                                context.l10n.order_details_actions,
                              ),
                              8.verticalSpace,
                              if (canCancelOrUpdate) ...[
                                BlocSelector<OrderDetailBloc, OrderDetailState, bool>(
                                  selector: (s) => s.actionStatus == OrderActionStatus.loading,
                                  builder: (context, isActionLoading) => Row(
                                    children: [
                                      Expanded(
                                        child: AppButton(
                                          label: context.l10n.order_details_cancel_btn,
                                          onPressed: isActionLoading ? null : () => _onCancelOrder(order),
                                          variant: ButtonVariant.danger,
                                        ),
                                      ),
                                      8.horizontalSpace,
                                      Expanded(
                                        child: AppButton(
                                          label: context.l10n.order_details_update_btn,
                                          onPressed: isActionLoading
                                              ? null
                                              : () {
                                                  unawaited(
                                                    context.showAppBottomSheet<void>(
                                                      builder: (_) => BlocProvider.value(
                                                        value: context.read<OrderDetailBloc>(),
                                                        child: UpdateOrderSheet(
                                                          order: order,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                          variant: ButtonVariant.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                16.verticalSpace,
                              ],
                              if (canDelete)
                                BlocSelector<OrderDetailBloc, OrderDetailState, bool>(
                                  selector: (s) => s.actionStatus == OrderActionStatus.loading,
                                  builder: (context, isActionLoading) => AppButton(
                                    label: context.l10n.order_delete_title,
                                    isFullWidth: true,
                                    onPressed: isActionLoading ? null : () => _onDeleteOrder(order),
                                    // ponytail: danger variant for consistent red delete buttons
                                    variant: ButtonVariant.danger,
                                  ),
                                ),
                              24.verticalSpace,
                            ],
                          ]),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final tt = context.theme.textTheme;
    final cs = context.theme.colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        title,
        style: tt.titleMedium?.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNotFoundState(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return AppEmptyState(
      icon: Icons.receipt_long_outlined,
      title: isAr ? 'الطلب غير موجود' : 'Order not found',
      subtitle: isAr
          ? 'قد يكون هذا الطلب تم حذفه أو لم يعد متاحاً.'
          : 'This order may have been deleted or is no longer available.',
      actionLabel: isAr ? 'العودة للطلبات' : 'Back to orders',
      onAction: () => context.pop(_shouldRefresh),
    );
  }
}
