import 'package:wassaly/core/imports/packages_imports.dart';

class OrderEntity extends Equatable {
  final String id;
  final String status;
  final double total;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.status,
    required this.total,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, status, total, createdAt];
}
