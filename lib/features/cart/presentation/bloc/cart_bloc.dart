import 'package:wassaly/core/imports/imports.dart';
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
  final CartRepository _cartRepository;

  CartBloc({
    required this.getCartItemsUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.updateQuantityUseCase,
    required CartRepository cartRepository,
  })  : _cartRepository = cartRepository,
        super(const CartState()) {
    on<LoadCartItemsEvent>(_onLoadCartItems);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<CheckIfInCartEvent>(_onCheckIfInCart);
    on<GetCartCountEvent>(_onGetCartCount);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) {
    emit(const CartState());
  }

  Future<void> _onLoadCartItems(
    LoadCartItemsEvent event,
    Emitter<CartState> emit,
  ) async {
    // Skip the loading indicator for background syncs (after add/remove/update)
    // so the UI doesn't flash a loading screen when the cart is already rendered.
    if (!event.silent) {
      emit(state.copyWith(status: CartStatus.loading, failure: null));
    }

    final result = await getCartItemsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: CartStatus.error,
        failure: failure,
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
      failure: null,
    ));

    final result = await addToCartUseCase(event.productId, event.quantity);

    result.fold(
      (failure) => emit(state.copyWith(
        addingProductIds: state.addingProductIds..remove(event.productId),
        failure: failure,
      )),
      (_) {
        final updatedIds = {...state.inCartProductIds, event.productId};
        emit(state.copyWith(
          inCartProductIds: updatedIds,
          addingProductIds: state.addingProductIds..remove(event.productId),
          cartCount: state.cartCount + 1,
        ));
        // Silent reload to sync with backend without flashing loading UI
        add(const LoadCartItemsEvent(silent: true));
      },
    );
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    // Optimistic UI Update: Remove item immediately
    final previousItems = List<CartItemEntity>.from(state.items);
    final previousIds = Set<int>.from(state.inCartProductIds);
    final previousCount = state.cartCount;

    // Find product ID to remove from set
    int? productIdToRemove;
    try {
      productIdToRemove = state.items
          .firstWhere((item) => item.id == event.cartItemId)
          .productId;
    } catch (_) {}

    final updatedItems = List<CartItemEntity>.from(state.items)
      ..removeWhere((item) => item.id == event.cartItemId);
    final updatedIds = Set<int>.from(state.inCartProductIds);
    if (productIdToRemove != null) {
      updatedIds.remove(productIdToRemove);
    }

    emit(state.copyWith(
      items: updatedItems,
      inCartProductIds: updatedIds,
      cartCount: state.cartCount > 0 ? state.cartCount - 1 : 0,
      addingProductIds: {...state.addingProductIds, event.cartItemId},
      failure: null,
    ));

    final result = await removeFromCartUseCase(event.cartItemId);

    result.fold(
      (failure) => emit(state.copyWith(
        items: previousItems, // Rollback
        inCartProductIds: previousIds, // Rollback
        cartCount: previousCount, // Rollback
        addingProductIds: state.addingProductIds..remove(event.cartItemId),
        failure: failure,
      )),
      (_) {
        emit(state.copyWith(
          addingProductIds: state.addingProductIds..remove(event.cartItemId),
        ));
        // Silent reload to sync with backend without flashing loading UI
        add(const LoadCartItemsEvent(silent: true));
      },
    );
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    // Optimistic UI Update: Update item immediately
    final previousItems = List<CartItemEntity>.from(state.items);

    final itemIndex =
        state.items.indexWhere((item) => item.id == event.cartItemId);

    if (itemIndex != -1) {
      final item = state.items[itemIndex];
      final newQuantity = event.quantity;
      final itemUnitPrice =
          item.quantity > 0 ? item.totalPrice / item.quantity : item.totalPrice;
      final newTotalPrice = itemUnitPrice * newQuantity;

      final updatedItem = item.copyWith(
        quantity: newQuantity,
        totalPrice: newTotalPrice,
      );

      final updatedItems = List<CartItemEntity>.from(state.items);
      updatedItems[itemIndex] = updatedItem;

      emit(state.copyWith(
        items: updatedItems,
        addingProductIds: {...state.addingProductIds, event.cartItemId},
        failure: null,
      ));
    } else {
      emit(state.copyWith(
        addingProductIds: {...state.addingProductIds, event.cartItemId},
        failure: null,
      ));
    }

    final result =
        await updateQuantityUseCase(event.cartItemId, event.quantity);

    result.fold(
      (failure) => emit(state.copyWith(
        items: previousItems, // Rollback
        addingProductIds: state.addingProductIds..remove(event.cartItemId),
        failure: failure,
      )),
      (_) {
        emit(state.copyWith(
          addingProductIds: state.addingProductIds..remove(event.cartItemId),
        ));
        // Silent reload to sync with backend without flashing loading UI
        add(const LoadCartItemsEvent(silent: true));
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
      await _cartRepository.saveCartItemsLocally(items);
    } catch (e) {
      // Silently fail - local storage is optional
    }
  }
}
