import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/domain/entities/order_entity.dart';
import 'package:wassaly/features/orders/presentation/bloc/order_detail/order_detail_bloc.dart';
import 'package:wassaly/features/orders/presentation/bloc/order_detail/order_detail_event.dart';
import 'package:wassaly/features/orders/presentation/bloc/order_detail/order_detail_state.dart';
import 'package:wassaly/features/orders/presentation/widgets/order_details/order_details_cards.dart';
import 'package:wassaly/features/orders/presentation/widgets/order_details/order_tracker_widget.dart';
import 'package:wassaly/features/orders/presentation/widgets/order_details/update_order_sheet.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  bool _isDeleting = false;
  bool _shouldRefresh = false;
  bool _allowPop = false;

  void _onRetry() {
    context.read<OrderDetailBloc>().add(FetchOrderDetailEvent(widget.orderId));
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
                        isFullWidth: false,
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
                        isFullWidth: false,
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
          listenWhen: (previous, current) =>
              previous.actionStatus != current.actionStatus,
          listener: (context, state) {
            if (state.actionStatus == OrderActionStatus.success) {
              context.showTypedSnackBar(
                _isDeleting
                    ? context.l10n.order_delete_success
                    : context.l10n.order_details_action_success,
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
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              AppSliverTopBar(
                title: context.l10n.order_details_title,
                onPressed: () => context.pop(_shouldRefresh),
              ),
              BlocBuilder<OrderDetailBloc, OrderDetailState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status ||
                    previous.order != current.order ||
                    previous.errorMessage != current.errorMessage,
                builder: (context, state) {
                  // Only show full loading on initial fetch (no order yet)
                  if (state.status == OrderDetailStatus.loading &&
                      state.order == null) {
                    return const SliverFillRemaining(
                      child: Center(child: AppLoading()),
                    );
                  }

                  if (state.status == OrderDetailStatus.failure &&
                      state.order == null) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: AppErrorWidget(
                          title: context.l10n.errors_error_occurred_title,
                          message: state.errorMessage.isNotEmpty
                              ? state.errorMessage
                              : context.l10n.errors_error_occurred_message,
                          onRetry: _onRetry,
                        ),
                      ),
                    );
                  }

                  final order = state.order;
                  if (order == null) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          context.l10n.errors_something_went_wrong,
                          style: tt.bodyLarge,
                        ),
                      ),
                    );
                  }

                  final normStatus = order.status.trim().toLowerCase();
                  final isCancelled = normStatus.contains('cancelled') ||
                      normStatus.contains('ملغي') ||
                      normStatus.contains('rejected') ||
                      normStatus.contains('failed');

                  final isPending = normStatus.contains('pending') ||
                      normStatus.contains('قيد الانتظار') ||
                      normStatus.contains('new') ||
                      normStatus.contains('جديد');

                  final isDelivered = normStatus.contains('delivered') ||
                      normStatus.contains('completed') ||
                      normStatus.contains('تم التوصيل') ||
                      normStatus.contains('مكتمل') ||
                      normStatus.contains('success');

                  final canDelete = isDelivered || isCancelled;
                  final canCancelOrUpdate = isPending;

                  return SliverPadding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // 1. Order Status Summary Header
                        OrderHeaderCard(order: order, isCancelled: isCancelled),
                        16.verticalSpace,

                        // 2. Beautiful Cancellation Alert if cancelled
                        if (isCancelled) ...[
                          const OrderCancelledAlert(),
                          16.verticalSpace,
                        ],

                        // 3. Gorgeous Interactive Status Timeline Card
                        _buildSectionHeader(
                            context, context.l10n.order_details_status),
                        8.verticalSpace,
                        AppCard(
                          showShadow: true,
                          padding: EdgeInsets.all(16.r),
                          child: OrderTrackerWidget(status: order.status),
                        ),
                        16.verticalSpace,

                        // 4. Delivery & Customer Address Card
                        _buildSectionHeader(
                            context, context.l10n.order_details_delivery_info),
                        8.verticalSpace,
                        OrderDeliveryInfoCard(order: order),
                        16.verticalSpace,

                        // 5. Order Items / Products Card
                        _buildSectionHeader(context,
                            context.l10n.order_details_ordered_products),
                        8.verticalSpace,
                        OrderItemsCard(items: order.items),
                        16.verticalSpace,

                        // 6. Detailed Receipt/Payment Card
                        _buildSectionHeader(context,
                            context.l10n.order_details_payment_summary),
                        8.verticalSpace,
                        OrderReceiptSummaryCard(order: order),
                        24.verticalSpace,

                        // 7. Action Buttons
                        if (canDelete || canCancelOrUpdate) ...[
                          _buildSectionHeader(
                              context, context.l10n.order_details_actions),
                          8.verticalSpace,
                          if (canCancelOrUpdate) ...[
                            BlocSelector<OrderDetailBloc, OrderDetailState,
                                bool>(
                              selector: (s) =>
                                  s.actionStatus == OrderActionStatus.loading,
                              builder: (context, isActionLoading) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        label: context
                                            .l10n.order_details_cancel_btn,
                                        onPressed: isActionLoading
                                            ? null
                                            : () => _onCancelOrder(order),
                                        variant: ButtonVariant.danger,
                                      ),
                                    ),
                                    8.horizontalSpace,
                                    Expanded(
                                      child: AppButton(
                                        label: context
                                            .l10n.order_details_update_btn,
                                        onPressed: isActionLoading
                                            ? null
                                            : () {
                                                context
                                                    .showAppBottomSheet<void>(
                                                  builder: (_) =>
                                                      BlocProvider.value(
                                                    value: context.read<
                                                        OrderDetailBloc>(),
                                                    child: UpdateOrderSheet(
                                                        order: order),
                                                  ),
                                                );
                                              },
                                        variant: ButtonVariant.secondary,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            16.verticalSpace,
                          ],
                          if (canDelete)
                            BlocSelector<OrderDetailBloc, OrderDetailState,
                                bool>(
                              selector: (s) =>
                                  s.actionStatus == OrderActionStatus.loading,
                              builder: (context, isActionLoading) {
                                return AppButton(
                                  label: context.l10n.order_delete_title,
                                  isFullWidth: true,
                                  onPressed: isActionLoading
                                      ? null
                                      : () => _onDeleteOrder(order),
                                  variant: ButtonVariant.outline,
                                  textColor: context.theme.colorScheme.error,
                                );
                              },
                            ),
                          24.verticalSpace,
                        ],
                      ]),
                    ),
                  );
              },
            ),
          ],
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
}
