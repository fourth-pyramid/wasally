import 'package:wassaly/core/imports/imports.dart';

abstract class OrderDetailEvent extends Equatable {
  const OrderDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchOrderDetailEvent extends OrderDetailEvent {
  final int orderId;

  const FetchOrderDetailEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class CancelOrderEvent extends OrderDetailEvent {
  final int orderId;

  const CancelOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdateOrderEvent extends OrderDetailEvent {
  final int orderId;
  final Map<String, dynamic> data;

  const UpdateOrderEvent(this.orderId, this.data);

  @override
  List<Object?> get props => [orderId, data];
}

class DeleteOrderEvent extends OrderDetailEvent {
  final int orderId;

  const DeleteOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
