import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/domain/entities/order_entity.dart';
import 'package:wassaly/features/orders/domain/entities/order_item_entity.dart';

class OrderHeaderCard extends StatelessWidget {
  final OrderEntity order;
  final bool isCancelled;

  const OrderHeaderCard({
    super.key,
    required this.order,
    required this.isCancelled,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return AppCard(
      showShadow: true,
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: isCancelled
                      ? cs.error.withValues(alpha: 0.1)
                      : cs.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCancelled
                      ? Icons.cancel_outlined
                      : Icons.shopping_bag_outlined,
                  color: isCancelled ? cs.error : cs.primary,
                  size: 24.r,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${context.l10n.order_details_order_no} #${order.orderNumber}',
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      order.createdAt.to12HourFormat(),
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isCancelled
                      ? cs.error.withValues(alpha: 0.1)
                      : cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  order.status,
                  style: tt.labelMedium?.copyWith(
                    color: isCancelled ? cs.error : cs.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderCancelledAlert extends StatelessWidget {
  const OrderCancelledAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: cs.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: cs.error),
          12.horizontalSpace,
          Expanded(
            child: Text(
              context.l10n.order_details_cancelled_msg,
              style: tt.bodySmall?.copyWith(
                color: cs.onErrorContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDeliveryInfoCard extends StatelessWidget {
  final OrderEntity order;

  const OrderDeliveryInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return AppCard(
      showShadow: true,
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            Icons.person_outline,
            context.l10n.order_details_customer,
            order.customerName ?? '',
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: AppDivider(color: cs.outlineVariant.withValues(alpha: 0.3)),
          ),
          _buildInfoRow(
            context,
            Icons.phone_outlined,
            context.l10n.order_details_phone,
            order.customerPhone ?? '',
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: AppDivider(color: cs.outlineVariant.withValues(alpha: 0.3)),
          ),
          _buildInfoRow(
            context,
            Icons.location_on_outlined,
            context.l10n.order_details_address,
            '${order.governorateName}, ${order.centerName}, ${order.deliveryAddress}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String title, String content) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20.r, color: cs.primary),
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              4.verticalSpace,
              Text(
                content.isNotEmpty ? content : '---',
                style: tt.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderItemsCard extends StatelessWidget {
  final List<OrderItemEntity> items;

  const OrderItemsCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return AppCard(
      showShadow: true,
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final product = item.product;

          final productName =
              product?.name ?? context.l10n.order_details_unknown_product;
          final productImage = product?.image ?? '';
          final quantity = item.quantity;
          final unitPrice = item.price;
          final totalItemPrice = item.totalPrice;

          return Column(
            children: [
              Row(
                children: [
                  // 1. Image
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                          color: cs.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: AppCachedImage(
                      imageUrl: productImage,
                      borderRadius: BorderRadius.circular(12.r),
                      fit: BoxFit.cover,
                    ),
                  ),
                  12.horizontalSpace,

                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName,
                          style: tt.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        4.verticalSpace,
                        Row(
                          children: [
                            Text(
                              '$quantity',
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' × ',
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '${unitPrice.toStringAsFixed(2)} ${context.l10n.shared_currency_egp}',
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Total Item Price
                  Text(
                    '${totalItemPrice.toStringAsFixed(2)} ${context.l10n.shared_currency_egp}',
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
              if (index != items.length - 1)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: AppDivider(
                      color: cs.outlineVariant.withValues(alpha: 0.3)),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class OrderReceiptSummaryCard extends StatelessWidget {
  final OrderEntity order;

  const OrderReceiptSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return AppCard(
      showShadow: true,
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          _buildReceiptRow(
            context,
            context.l10n.order_details_subtotal,
            '${(order.subTotal ?? 0).toStringAsFixed(2)} ${context.l10n.shared_currency_egp}',
          ),
          8.verticalSpace,
          _buildReceiptRow(
            context,
            context.l10n.order_details_delivery_fees,
            '${order.deliveryFees.toStringAsFixed(2)} ${context.l10n.shared_currency_egp}',
          ),
          if ((order.discountAmount ?? 0) > 0) ...[
            8.verticalSpace,
            _buildReceiptRow(
              context,
              context.l10n.order_details_discount,
              '- ${(order.discountAmount ?? 0).toStringAsFixed(2)} ${context.l10n.shared_currency_egp}',
              isDiscount: true,
            ),
          ],
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: AppDivider(color: cs.outlineVariant.withValues(alpha: 0.3)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.order_details_total,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              Text(
                '${order.totalPrice.toStringAsFixed(2)} ${context.l10n.shared_currency_egp}',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.payment_outlined, size: 20.r, color: cs.primary),
                12.horizontalSpace,
                Text(
                  context.l10n.order_details_payment_method,
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                const Spacer(),
                Text(
                  order.paymentMethod,
                  style: tt.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(BuildContext context, String title, String value,
      {bool isDiscount = false}) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
        Text(
          value,
          style: tt.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDiscount ? cs.error : cs.onSurface,
          ),
        ),
      ],
    );
  }
}
