import '../../domain/entities/order_entity.dart';

class OrderModel {
  final String id;
  final String status;
  final double total;
  final String createdAt;

  const OrderModel({
    required this.id,
    required this.status,
    required this.total,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return OrderModel(
      id: data['id']?.toString() ?? '',
      status: data['status']?.toString() ?? '',
      total: (data['total_price'] as num?)?.toDouble() ??
          (data['total'] as num?)?.toDouble() ??
          0.0,
      createdAt: data['created_at']?.toString() ?? '',
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      status: status,
      total: total,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
    );
  }
}
