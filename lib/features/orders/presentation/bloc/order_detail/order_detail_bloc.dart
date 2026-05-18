import 'package:wassaly/core/imports/imports.dart';
import '../../../domain/usecases/get_order_details_usecase.dart';
import '../../../domain/usecases/cancel_order_usecase.dart';
import '../../../domain/usecases/update_order_usecase.dart';
import '../../../domain/usecases/delete_order_usecase.dart';
import 'order_detail_event.dart';
import 'order_detail_state.dart';

class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;
  final UpdateOrderUseCase _updateOrderUseCase;
  final DeleteOrderUseCase _deleteOrderUseCase;

  OrderDetailBloc({
    required GetOrderDetailsUseCase getOrderDetailsUseCase,
    required CancelOrderUseCase cancelOrderUseCase,
    required UpdateOrderUseCase updateOrderUseCase,
    required DeleteOrderUseCase deleteOrderUseCase,
  })  : _getOrderDetailsUseCase = getOrderDetailsUseCase,
        _cancelOrderUseCase = cancelOrderUseCase,
        _updateOrderUseCase = updateOrderUseCase,
        _deleteOrderUseCase = deleteOrderUseCase,
        super(const OrderDetailState()) {
    on<FetchOrderDetailEvent>(_onFetchOrderDetail);
    on<CancelOrderEvent>(_onCancelOrder);
    on<UpdateOrderEvent>(_onUpdateOrder);
    on<DeleteOrderEvent>(_onDeleteOrder);
  }

  Future<void> _onFetchOrderDetail(
    FetchOrderDetailEvent event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(state.copyWith(status: OrderDetailStatus.loading, errorMessage: ''));

    final result = await _getOrderDetailsUseCase(event.orderId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: OrderDetailStatus.failure,
        errorMessage: failure.message,
      )),
      (order) => emit(state.copyWith(
        status: OrderDetailStatus.success,
        order: order,
      )),
    );
  }

  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(state.copyWith(actionStatus: OrderActionStatus.loading, actionErrorMessage: ''));

    final result = await _cancelOrderUseCase(event.orderId);

    result.fold(
      (failure) => emit(state.copyWith(
        actionStatus: OrderActionStatus.failure,
        actionErrorMessage: failure.message,
      )),
      (_) {
        emit(state.copyWith(actionStatus: OrderActionStatus.success));
        // Refresh details
        add(FetchOrderDetailEvent(event.orderId));
      },
    );
  }

  Future<void> _onUpdateOrder(
    UpdateOrderEvent event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(state.copyWith(actionStatus: OrderActionStatus.loading, actionErrorMessage: ''));

    final result = await _updateOrderUseCase(UpdateOrderParams(orderId: event.orderId, data: event.data));

    await result.fold(
      (failure) async => emit(state.copyWith(
        actionStatus: OrderActionStatus.failure,
        actionErrorMessage: failure.message,
      )),
      (_) async {
        // Refresh order details FIRST before emitting success
        final refreshResult = await _getOrderDetailsUseCase(event.orderId);
        refreshResult.fold(
          (_) => null, // ignore refresh error silently
          (updatedOrder) => emit(state.copyWith(
            status: OrderDetailStatus.success,
            order: updatedOrder,
          )),
        );
        // Now emit success to close the sheet with updated data already in state
        emit(state.copyWith(actionStatus: OrderActionStatus.success));
      },
    );
  }

  Future<void> _onDeleteOrder(
    DeleteOrderEvent event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(state.copyWith(actionStatus: OrderActionStatus.loading, actionErrorMessage: ''));

    final result = await _deleteOrderUseCase(event.orderId);

    result.fold(
      (failure) => emit(state.copyWith(
        actionStatus: OrderActionStatus.failure,
        actionErrorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(actionStatus: OrderActionStatus.success)),
    );
  }
}
