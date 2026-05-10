import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartItemsEvent extends CartEvent {
  const LoadCartItemsEvent();
}

class AddToCartEvent extends CartEvent {
  final int productId;
  final int quantity;

  const AddToCartEvent(this.productId, {this.quantity = 1});

  @override
  List<Object?> get props => [productId, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final int cartItemId;

  const RemoveFromCartEvent(this.cartItemId);

  @override
  List<Object?> get props => [cartItemId];
}

class UpdateQuantityEvent extends CartEvent {
  final int cartItemId;
  final int quantity;

  const UpdateQuantityEvent({required this.cartItemId, required this.quantity});

  @override
  List<Object?> get props => [cartItemId, quantity];
}

class CheckIfInCartEvent extends CartEvent {
  final int productId;

  const CheckIfInCartEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class GetCartCountEvent extends CartEvent {
  const GetCartCountEvent();
}
