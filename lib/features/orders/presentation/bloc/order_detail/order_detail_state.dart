import 'package:wassaly/core/imports/imports.dart';
import '../../../domain/entities/order_entity.dart';

enum OrderDetailStatus { initial, loading, success, failure }
enum OrderActionStatus { initial, loading, success, failure }

class OrderDetailState extends Equatable {
  final OrderDetailStatus status;
  final OrderActionStatus actionStatus;
  final OrderEntity? order;
  final String errorMessage;
  final String actionErrorMessage;

  const OrderDetailState({
    this.status = OrderDetailStatus.initial,
    this.actionStatus = OrderActionStatus.initial,
    this.order,
    this.errorMessage = '',
    this.actionErrorMessage = '',
  });

  OrderDetailState copyWith({
    OrderDetailStatus? status,
    OrderActionStatus? actionStatus,
    OrderEntity? order,
    String? errorMessage,
    String? actionErrorMessage,
  }) {
    return OrderDetailState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      order: order ?? this.order,
      errorMessage: errorMessage ?? this.errorMessage,
      actionErrorMessage: actionErrorMessage ?? this.actionErrorMessage,
    );
  }

  @override
  List<Object?> get props => [status, actionStatus, order, errorMessage, actionErrorMessage];
}
