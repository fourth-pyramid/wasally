import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';
import 'package:wassaly/features/service_booking/domain/usecases/get_my_bookings_usecase.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrdersUseCase getOrdersUseCase;
  final GetMyBookingsUseCase getMyBookingsUseCase;

  OrdersBloc({
    required this.getOrdersUseCase,
    required this.getMyBookingsUseCase,
  }) : super(const OrdersState()) {
    on<GetOrdersEvent>(_onGetOrders);
    on<GetServiceBookingsEvent>(_onGetServiceBookings);
    on<LoadMoreOrdersEvent>(_onLoadMoreOrders);
    on<ResetOrdersEvent>((event, emit) => emit(const OrdersState()));
  }

  Future<void> _onGetOrders(
      GetOrdersEvent event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(
      status: OrdersStatus.loading,
      orders: const PaginatedResponse<OrderEntity>(data: []),
      errorMessage: '',
    ));

    final result = await getOrdersUseCase(page: 1);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: OrdersStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (paginatedResponse) {
        emit(state.copyWith(
          status: OrdersStatus.success,
          orders: paginatedResponse,
        ));
      },
    );
  }

  Future<void> _onGetServiceBookings(
      GetServiceBookingsEvent event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(
      serviceStatus: OrdersStatus.loading,
      serviceBookings: const PaginatedResponse<BookingEntity>(data: []),
      errorMessage: '',
    ));

    final result = await getMyBookingsUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          serviceStatus: OrdersStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (bookings) {
        emit(state.copyWith(
          serviceStatus: OrdersStatus.success,
          serviceBookings: PaginatedResponse<BookingEntity>(
            data: bookings,
            currentPage: 1,
            lastPage: 1,
            total: bookings.length,
          ),
        ));
      },
    );
  }

  Future<void> _onLoadMoreOrders(
      LoadMoreOrdersEvent event, Emitter<OrdersState> emit) async {
    if (state.status == OrdersStatus.loading || !state.orders.hasMore) {
      return;
    }

    final nextPage = state.orders.currentPage + 1;

    final result = await getOrdersUseCase(page: nextPage);

    result.fold(
      (failure) {
        // We don't change status to failure here to keep showing current orders
      },
      (paginatedResponse) {
        emit(state.copyWith(
          orders: paginatedResponse.copyWith(
            data: [...state.orders.data, ...paginatedResponse.data],
          ),
        ));
      },
    );
  }
}
