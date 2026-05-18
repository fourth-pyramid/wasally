import '../../domain/entities/order_entity.dart';
import 'order_item_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.orderNumber,
    required super.status,
    required super.totalPrice,
    required super.paymentMethod,
    required super.deliveryFees,
    required super.items,
    required super.createdAt,
    super.subTotal,
    super.discountAmount,
    super.customerName,
    super.customerPhone,
    super.deliveryAddress,
    super.governorateId,
    super.governorateName,
    super.centerId,
    super.centerName,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int? ?? 0,
      orderNumber: json['order_number'] as String? ?? '',
      status: json['status'] as String? ?? '',
      totalPrice: (json['total_price'] as num? ?? 0).toDouble(),
      paymentMethod: json['payment_method'] as String? ?? '',
      deliveryFees: (json['delivery_fees'] as num? ?? 0).toDouble(),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] as String? ?? '',
      subTotal: (json['sub_total'] as num?)?.toDouble(),
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      customerName: json['customer_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
      deliveryAddress: json['delivery_address'] as String?,
      governorateId: (json['governorate'] as Map<String, dynamic>?)?['id']?.toString(),
      governorateName: (json['governorate'] as Map<String, dynamic>?)?['name'] as String?,
      centerId: (json['center'] as Map<String, dynamic>?)?['id']?.toString(),
      centerName: (json['center'] as Map<String, dynamic>?)?['name'] as String?,
    );
  }
}

