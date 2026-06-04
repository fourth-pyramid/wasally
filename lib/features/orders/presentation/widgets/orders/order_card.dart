import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/domain/entities/order_entity.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_event.dart';
import 'package:wassaly/features/orders/presentation/widgets/order_status_config.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;

  const OrderCard({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: AppCard(
        showShadow: true,
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: () async {
            final result = await context.push<bool?>(
              AppRoutes.orderDetails,
              extra: {'orderId': order.id},
            );
            if ((result ?? false) && context.mounted) {
              context.read<OrdersBloc>().add(const GetOrdersEvent());
            }
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header: Status (Left) and Order Number (Right)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusBadge(status: order.status),
                    const Spacer(),
                    Text(
                      '#${order.orderNumber}',
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                AppDivider(color: cs.outlineVariant.withValues(alpha: 0.3)),
                16.verticalSpace,

                // 2. Middle Section: Total Price (Left), Items, Date/Time (Right)
                Row(
                  children: [
                    Text(
                      '${order.totalPrice} ${context.l10n.common_currency}',
                      style: tt.titleMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${order.items.length} ${context.l10n.order_items_count}',
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            8.horizontalSpace,
                            Icon(
                              Icons.shopping_basket_outlined,
                              size: 16.r,
                              color: cs.onSurfaceVariant,
                            ),
                          ],
                        ),
                        8.verticalSpace,
                        Row(
                          children: [
                            Text(
                              '${order.createdAt.toDateOnly()} - ${order.createdAt.to12HourTimeOnly()}',
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            8.horizontalSpace,
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 16.r,
                              color: cs.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                16.verticalSpace,
                AppDivider(color: cs.outlineVariant.withValues(alpha: 0.3)),
                16.verticalSpace,

                // 3. Footer: Payment Method
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        order.paymentMethod.toLowerCase().contains('cash') ||
                                order.paymentMethod.contains('كاش')
                            ? context.l10n.order_payment_cash
                            : order.paymentMethod,
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    8.horizontalSpace,
                    Icon(
                      Icons.payment_rounded,
                      size: 16.r,
                      color: cs.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final config = OrderStatusConfig.getConfig(context, status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          color: config.color,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
