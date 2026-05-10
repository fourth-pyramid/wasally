import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/injection/injection.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/get_cart_items_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_quantity_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase getCartItemsUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final UpdateQuantityUseCase updateQuantityUseCase;

  CartBloc({
    required this.getCartItemsUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.updateQuantityUseCase,
  }) : super(const CartState()) {
    on<LoadCartItemsEvent>(_onLoadCartItems);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<CheckIfInCartEvent>(_onCheckIfInCart);
    on<GetCartCountEvent>(_onGetCartCount);
  }

  Future<void> _onLoadCartItems(
    LoadCartItemsEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading, errorMessage: null));

    final result = await getCartItemsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: CartStatus.error,
        errorMessage: failure.message,
      )),
      (items) {
        // Save cart items locally for offline access
        _saveCartItemsLocally(items);

        return emit(state.copyWith(
          status: CartStatus.success,
          items: items,
          cartCount: items.length,
          inCartProductIds: items.map((e) => e.productId).toSet(),
        ));
      },
    );
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(
      addingProductIds: {...state.addingProductIds, event.productId},
      errorMessage: null,
    ));

    final result = await addToCartUseCase(event.productId, event.quantity);

    result.fold(
      (failure) => emit(state.copyWith(
        addingProductIds: state.addingProductIds..remove(event.productId),
        errorMessage: failure.message,
      )),
      (_) {
        final updatedIds = {...state.inCartProductIds, event.productId};
        emit(state.copyWith(
          inCartProductIds: updatedIds,
          addingProductIds: state.addingProductIds..remove(event.productId),
          cartCount: state.cartCount + 1,
        ));
      },
    );
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(
      addingProductIds: {...state.addingProductIds, event.cartItemId},
      errorMessage: null,
    ));

    final result = await removeFromCartUseCase(event.cartItemId);

    result.fold(
      (failure) => emit(state.copyWith(
        addingProductIds: state.addingProductIds..remove(event.cartItemId),
        errorMessage: failure.message,
      )),
      (_) {
        final updatedIds = Set<int>.from(state.inCartProductIds)
          ..remove(event.cartItemId);
        emit(state.copyWith(
          inCartProductIds: updatedIds,
          addingProductIds: state.addingProductIds..remove(event.cartItemId),
          cartCount: state.cartCount > 0 ? state.cartCount - 1 : 0,
        ));
      },
    );
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(
      addingProductIds: {...state.addingProductIds, event.cartItemId},
      errorMessage: null,
    ));

    final result =
        await updateQuantityUseCase(event.cartItemId, event.quantity);

    result.fold(
      (failure) => emit(state.copyWith(
        addingProductIds: state.addingProductIds..remove(event.cartItemId),
        errorMessage: failure.message,
      )),
      (_) {
        emit(state.copyWith(
          addingProductIds: state.addingProductIds..remove(event.cartItemId),
        ));
        // Reload cart items to get updated quantities
        add(const LoadCartItemsEvent());
      },
    );
  }

  Future<void> _onCheckIfInCart(
    CheckIfInCartEvent event,
    Emitter<CartState> emit,
  ) async {
    // Check if product is in cart locally based on cart items
    final isInCart =
        state.items.any((item) => item.productId == event.productId);

    final updatedIds = isInCart
        ? {...state.inCartProductIds, event.productId}
        : state.inCartProductIds;
    emit(state.copyWith(inCartProductIds: updatedIds));
  }

  Future<void> _onGetCartCount(
    GetCartCountEvent event,
    Emitter<CartState> emit,
  ) async {
    // Calculate cart count from existing cart items
    final cartCount = state.items.length;
    emit(state.copyWith(cartCount: cartCount));
  }

  // Helper method to save cart items locally
  Future<void> _saveCartItemsLocally(List<CartItemEntity> items) async {
    try {
      // Convert entities to models and save via repository
      final cartRepository = sl<CartRepository>();
      if (cartRepository is CartRepositoryImpl) {
        // Access the datasource directly to save locally
        final dataSource = (cartRepository).remoteDataSource;
        final itemsModels = items
            .map((entity) => CartItemModel(
                  id: entity.id,
                  productId: entity.productId,
                  productName: entity.productName,
                  productImage: entity.productImage,
                  price: entity.price,
                  quantity: entity.quantity,
                  unitPrice: entity.unitPrice,
                  totalPrice: entity.totalPrice,
                ))
            .toList();

        await dataSource.saveCartItemsLocally(itemsModels);
      }
    } catch (e) {
      // Silently fail - local storage is optional
      print('Failed to save cart items locally: $e');
    }
  }
}
