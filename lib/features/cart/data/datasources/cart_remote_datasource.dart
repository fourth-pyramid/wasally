import '../../../../core/imports/core_imports.dart';
import '../../../cart/domain/entities/place_order_params.dart';
import '../models/cart_item_model.dart';
import '../models/coupon_model.dart';
import '../models/order_model.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addToCart(int productId, int quantity);
  Future<void> removeFromCart(int productId);
  Future<void> updateQuantity(int productId, int quantity);
  Future<CouponModel> applyCoupon(String code);
  Future<OrderModel> placeOrder(PlaceOrderParams params);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final DioService _dioService;

  const CartRemoteDataSourceImpl(this._dioService);

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final response = await _dioService.get('/api/carts');

    return response.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>?;
        final status = responseData?['status'] as bool? ?? false;

        if (!status) {
          throw ServerFailure(responseData?['message']?.toString() ??
              'Failed to get cart items');
        }

        final cartData = responseData?['data'] as Map<String, dynamic>?;
        final items = cartData?['items'] as List<dynamic>? ?? [];
        return items
            .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<void> addToCart(int productId, int quantity) async {
    final response = await _dioService.post(
      '/api/carts/add',
      data: {
        'product_id': productId,
        'quantity': quantity,
      },
    );

    return response.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>?;
        final status = responseData?['status'] as bool? ?? false;

        if (!status) {
          throw ServerFailure(
              responseData?['message']?.toString() ?? 'Failed to add to cart');
        }
      },
    );
  }

  @override
  Future<void> removeFromCart(int cartItemId) async {
    final response = await _dioService.delete(
      '/api/carts/remove?cart_item_id=$cartItemId',
    );

    return response.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>?;
        final status = responseData?['status'] as bool? ?? false;

        if (!status) {
          throw ServerFailure(responseData?['message']?.toString() ??
              'Failed to remove from cart');
        }
      },
    );
  }

  @override
  Future<void> updateQuantity(int cartItemId, int quantity) async {
    final response = await _dioService.put(
      '/api/carts/update',
      data: {
        'cart_item_id': cartItemId,
        'quantity': quantity,
      },
    );

    return response.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>?;
        final status = responseData?['status'] as bool? ?? false;

        if (!status) {
          throw ServerFailure(responseData?['message']?.toString() ??
              'Failed to update quantity');
        }
      },
    );
  }

  @override
  Future<CouponModel> applyCoupon(String code) async {
    final response = await _dioService.post(
      '/api/coupons/apply',
      data: {'code': code},
    );

    return response.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>?;
        final status = responseData?['status'] as bool? ?? false;

        if (!status) {
          throw ServerFailure(
              responseData?['message']?.toString() ?? 'Failed to apply coupon');
        }

        final data = responseData!['data'] as Map<String, dynamic>;
        final isValid = data['is_valid'] as bool? ?? true;

        if (!isValid) {
          throw ServerFailure(
              responseData['message']?.toString() ?? 'Coupon is not valid');
        }

        return CouponModel.fromJson(data);
      },
    );
  }

  @override
  Future<OrderModel> placeOrder(PlaceOrderParams params) async {
    final items = params.items
        .map((item) => {
              'product_id': item.productId,
              'quantity': item.quantity,
            })
        .toList();

    final data = <String, dynamic>{
      'customer_name': params.customerName,
      'customer_phone': params.customerPhone,
      'customer_address': params.customerAddress,
      'governorate_id': params.governorateId,
      'region': params.region,
      'center_id': params.centerId,
      'items': items,
      if (params.couponCode != null && params.couponCode!.isNotEmpty)
        'coupon_code': params.couponCode,
    };

    final response = await _dioService.post('/api/carts/checkout', data: data);

    return response.fold(
      (failure) => throw failure,
      (response) {
        final responseData = response.data as Map<String, dynamic>?;
        final status = responseData?['status'] as bool? ?? false;

        if (!status) {
          throw ServerFailure(
              responseData?['message']?.toString() ?? 'Failed to place order');
        }

        return OrderModel.fromJson(responseData!);
      },
    );
  }
}
