import 'package:equatable/equatable.dart';

import '../../domain/entities/cart_item_entity.dart';

enum CartStatus { initial, loading, success, error }

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItemEntity> items;
  final int cartCount;
  final Set<int> inCartProductIds;
  final Set<int> addingProductIds;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.cartCount = 0,
    this.inCartProductIds = const {},
    this.addingProductIds = const {},
    this.errorMessage,
  });

  bool get isLoading => status == CartStatus.loading;
  bool get isSuccess => status == CartStatus.success;
  bool get isError => status == CartStatus.error;

  bool isInCart(int productId) => inCartProductIds.contains(productId);
  bool isAdding(int productId) => addingProductIds.contains(productId);

  CartState copyWith({
    CartStatus? status,
    List<CartItemEntity>? items,
    int? cartCount,
    Set<int>? inCartProductIds,
    Set<int>? addingProductIds,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      cartCount: cartCount ?? this.cartCount,
      inCartProductIds: inCartProductIds ?? this.inCartProductIds,
      addingProductIds: addingProductIds ?? this.addingProductIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        cartCount,
        inCartProductIds,
        addingProductIds,
        errorMessage,
      ];
}
