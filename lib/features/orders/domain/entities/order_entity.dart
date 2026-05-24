import 'package:wassaly/core/imports/imports.dart';
import 'order_item_entity.dart';

class OrderEntity extends Equatable {
  final int id;
  final String orderNumber;
  final String status;
  final double totalPrice;
  final String paymentMethod;
  final double deliveryFees;
  final List<OrderItemEntity> items;
  final String createdAt;
  final double? subTotal;
  final double? discountAmount;
  final String? customerName;
  final String? customerPhone;
  final String? deliveryAddress;
  final String? governorateId;
  final String? governorateName;
  final String? centerId;
  final String? centerName;

  const OrderEntity({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalPrice,
    required this.paymentMethod,
    required this.deliveryFees,
    required this.items,
    required this.createdAt,
    this.subTotal,
    this.discountAmount,
    this.customerName,
    this.customerPhone,
    this.deliveryAddress,
    this.governorateId,
    this.governorateName,
    this.centerId,
    this.centerName,
  });

  bool get isCancelled {
    final normStatus = status.trim().toLowerCase();
    return normStatus.contains('cancelled') ||
        normStatus.contains('ملغي') ||
        normStatus.contains('rejected') ||
        normStatus.contains('failed');
  }

  bool get isPending {
    final normStatus = status.trim().toLowerCase();
    return normStatus.contains('pending') ||
        normStatus.contains('قيد الانتظار') ||
        normStatus.contains('new') ||
        normStatus.contains('جديد');
  }

  bool get isDelivered {
    final normStatus = status.trim().toLowerCase();
    return normStatus.contains('delivered') ||
        normStatus.contains('completed') ||
        normStatus.contains('تم التوصيل') ||
        normStatus.contains('مكتمل') ||
        normStatus.contains('success');
  }

  bool get canDelete => isDelivered || isCancelled;
  bool get canCancelOrUpdate => isPending;

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        status,
        totalPrice,
        paymentMethod,
        deliveryFees,
        items,
        createdAt,
        subTotal,
        discountAmount,
        customerName,
        customerPhone,
        deliveryAddress,
        governorateId,
        governorateName,
        centerId,
        centerName,
      ];
}
