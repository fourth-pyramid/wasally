import 'package:wassaly/core/imports/imports.dart';

import '../../../../features/profile/domain/entities/address_entity.dart';
import '../../domain/entities/cart_checkout_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/coupon_entity.dart';

enum CartStatus { initial, loading, success, error }

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItemEntity> items;
  final int cartCount;
  final Set<int> inCartProductIds;
  final Set<int> addingProductIds;
  final Failure? failure;

  // Address fields
  final List<AddressEntity> addresses;
  final AddressEntity? selectedAddress;
  final bool isLoadingAddresses;
  final Failure? addressesFailure;

  // Checkout data (for calculating shipping in cart page)
  final CartCheckoutEntity? checkoutData;

  // Coupon data
  final CouponEntity? appliedCoupon;
  final bool isApplyingCoupon;
  final Failure? couponFailure;

  const CartState({
    this.status = CartStatus.initial,
    this.items = const [],
    this.cartCount = 0,
    this.inCartProductIds = const {},
    this.addingProductIds = const {},
    this.failure,
    this.addresses = const [],
    this.selectedAddress,
    this.isLoadingAddresses = false,
    this.addressesFailure,
    this.checkoutData,
    this.appliedCoupon,
    this.isApplyingCoupon = false,
    this.couponFailure,
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
    Failure? failure,
    List<AddressEntity>? addresses,
    AddressEntity? selectedAddress,
    bool? isLoadingAddresses,
    Failure? addressesFailure,
    CartCheckoutEntity? checkoutData,
    CouponEntity? appliedCoupon,
    bool? isApplyingCoupon,
    Failure? couponFailure,
    bool clearError = false,
    bool clearAddressesError = false,
    bool clearCouponError = false,
    bool clearSelectedAddress = false,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      cartCount: cartCount ?? this.cartCount,
      inCartProductIds: inCartProductIds ?? this.inCartProductIds,
      addingProductIds: addingProductIds ?? this.addingProductIds,
      failure: clearError ? null : failure ?? this.failure,
      addresses: addresses ?? this.addresses,
      selectedAddress:
          clearSelectedAddress ? null : selectedAddress ?? this.selectedAddress,
      isLoadingAddresses: isLoadingAddresses ?? this.isLoadingAddresses,
      addressesFailure: clearAddressesError
          ? null
          : addressesFailure ?? this.addressesFailure,
      checkoutData: checkoutData ?? this.checkoutData,
      appliedCoupon: appliedCoupon ?? this.appliedCoupon,
      isApplyingCoupon: isApplyingCoupon ?? this.isApplyingCoupon,
      couponFailure:
          clearCouponError ? null : couponFailure ?? this.couponFailure,
    );
  }

  // Calculated getters
  double get totalOriginalPrice => items.fold<double>(
        0,
        (sum, item) =>
            sum + (double.tryParse(item.price) ?? 0.0) * item.quantity,
      );

  double get totalAfterProductOffers => items.fold<double>(
        0,
        (sum, item) {
          final originalPrice = double.tryParse(item.price) ?? 0.0;
          final hasOffer = item.offers != null && item.offers!.isNotEmpty;
          final discountedPrice = hasOffer
              ? originalPrice *
                  (1 - (item.offers!.first.discountPercentage / 100))
              : originalPrice;
          return sum + (discountedPrice * item.quantity);
        },
      );

  double get productOffersDiscount =>
      totalOriginalPrice - totalAfterProductOffers;

  double get total => totalAfterProductOffers.clamp(0.0, double.infinity);

  @override
  List<Object?> get props => [
        status,
        items,
        cartCount,
        inCartProductIds,
        addingProductIds,
        failure,
        addresses,
        selectedAddress,
        isLoadingAddresses,
        addressesFailure,
        checkoutData,
        appliedCoupon,
        isApplyingCoupon,
        couponFailure,
      ];

  // Backward compatibility getters
  String get errorMessage => failure?.message ?? '';
  String get addressesError => addressesFailure?.message ?? '';
  String get couponError => couponFailure?.message ?? '';
}
