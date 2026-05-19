import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';
import '../../domain/entities/order_entity.dart';

enum OrdersStatus { initial, loading, loadingMore, success, failure }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final PaginatedResponse<OrderEntity> orders;
  final OrdersStatus serviceStatus;
  final PaginatedResponse<BookingEntity> serviceBookings;
  final String errorMessage;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const PaginatedResponse(data: []),
    this.serviceStatus = OrdersStatus.initial,
    this.serviceBookings = const PaginatedResponse(data: []),
    this.errorMessage = '',
  });

  OrdersState copyWith({
    OrdersStatus? status,
    PaginatedResponse<OrderEntity>? orders,
    OrdersStatus? serviceStatus,
    PaginatedResponse<BookingEntity>? serviceBookings,
    String? errorMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      serviceStatus: serviceStatus ?? this.serviceStatus,
      serviceBookings: serviceBookings ?? this.serviceBookings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orders,
        serviceStatus,
        serviceBookings,
        errorMessage,
      ];
}
