import 'package:wassaly/core/imports/imports.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class GetOrdersEvent extends OrdersEvent {
  const GetOrdersEvent();
}

class GetServiceBookingsEvent extends OrdersEvent {
  const GetServiceBookingsEvent();
}

class LoadMoreOrdersEvent extends OrdersEvent {
  const LoadMoreOrdersEvent();
}

class ResetOrdersEvent extends OrdersEvent {
  const ResetOrdersEvent();
}
