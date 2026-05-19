import 'dart:math';

import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_event.dart';

import '../../../../../features/cart/domain/entities/cart_item_entity.dart';
import '../../../../../features/cart/domain/entities/coupon_entity.dart';
import '../../../../../features/cart/domain/entities/order_entity.dart';
import '../../../../../features/cart/domain/entities/place_order_params.dart';
import '../../../../../features/cart/domain/usecases/apply_coupon_usecase.dart';
import '../../../../../features/cart/domain/usecases/get_user_addresses_usecase.dart';
import '../../../../../features/cart/domain/usecases/get_user_data_usecase.dart';
import '../../../../../features/cart/domain/usecases/place_order_usecase.dart';
import '../../../../../features/profile/domain/entities/address_entity.dart';
import '../../../../../features/profile/domain/entities/center_entity.dart';
import '../../../../../features/profile/domain/entities/governorate_entity.dart';
import '../../../../../features/profile/domain/usecases/get_centers_usecase.dart';
import '../../../../../features/profile/domain/usecases/get_governorates_usecase.dart';
import '../cart_state.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final PlaceOrderUseCase _placeOrderUseCase;
  final ApplyCouponUseCase _applyCouponUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCentersUseCase _getCentersUseCase;
  final GetUserDataUseCase _getUserDataUseCase;
  final GetUserAddressesUseCase _getUserAddressesUseCase;
  final OrdersBloc _ordersBloc;

  CheckoutBloc({
    required PlaceOrderUseCase placeOrderUseCase,
    required ApplyCouponUseCase applyCouponUseCase,
    required GetGovernoratesUseCase getGovernoratesUseCase,
    required GetCentersUseCase getCentersUseCase,
    required GetUserDataUseCase getUserDataUseCase,
    required GetUserAddressesUseCase getUserAddressesUseCase,
    required OrdersBloc ordersBloc,
  })  : _placeOrderUseCase = placeOrderUseCase,
        _applyCouponUseCase = applyCouponUseCase,
        _getGovernoratesUseCase = getGovernoratesUseCase,
        _getCentersUseCase = getCentersUseCase,
        _getUserDataUseCase = getUserDataUseCase,
        _getUserAddressesUseCase = getUserAddressesUseCase,
        _ordersBloc = ordersBloc,
        super(const CheckoutState()) {
    on<CheckoutInitialized>(_onCheckoutInitialized);
    on<CheckoutGovernorateSelected>(_onGovernorateSelected);
    on<CheckoutCenterSelected>(_onCenterSelected);
    on<CheckoutFormChanged>(_onFormChanged);
    on<CheckoutCouponApplied>(_onCouponApplied);
    on<CheckoutCouponRemoved>(_onCouponRemoved);
    on<CheckoutSubmitted>(_onCheckoutSubmitted);
    on<CheckoutAddressSelected>(_onAddressSelected);
    on<CheckoutAddressesRefreshed>(_onAddressesRefreshed);
  }

  // ─── Pure Calculation Helpers ────────────────────────────────────────────────

  double _calculateSubtotal(List<CartItemEntity> items) => items.fold(
      0,
      (sum, item) =>
          sum + (double.tryParse(item.price) ?? 0.0) * item.quantity);

  double _calculateProductDiscounts(List<CartItemEntity> items) =>
      items.fold(0, (sum, item) {
        final originalPrice = double.tryParse(item.price) ?? 0.0;
        final hasOffer = item.offers != null && item.offers!.isNotEmpty;
        final discountedPrice = hasOffer
            ? originalPrice *
                (1 - (item.offers!.first.discountPercentage / 100))
            : originalPrice;
        return sum + ((originalPrice - discountedPrice) * item.quantity);
      });

  double _calculateDiscount(CouponEntity coupon, double subtotal) {
    final value = (coupon.value as num).toDouble();
    if (coupon.type == 'percentage') {
      return subtotal * value / 100;
    }
    return value;
  }

  double _calculateTotal(double subtotal, double productDiscounts,
          double shipping, double discount) =>
      max(0, subtotal - productDiscounts + shipping - discount);

  // ─── Event Handlers ──────────────────────────────────────────────────────────

  Future<void> _onCheckoutInitialized(
    CheckoutInitialized event,
    Emitter<CheckoutState> emit,
  ) async {
    final cartState = event.cartState;
    final items = cartState.items;
    final subtotal = _calculateSubtotal(items);
    final productDiscounts = _calculateProductDiscounts(items);

    // Pre-fill from checkout data (from cart state)
    final checkoutData = cartState.checkoutData;
    final user = checkoutData?.user;

    String prefilledName = user?.name ?? '';
    String prefilledPhone = user?.phone ?? '';
    final prefilledAddress = checkoutData?.selectedAddress?.address ?? '';
    final prefilledGovernorateId =
        checkoutData?.selectedAddress?.governorateId ??
            checkoutData?.governorate?.id;

    emit(state.copyWith(
      status: CheckoutStatus.loading,
      items: items,
      subtotal: subtotal,
      productDiscounts: productDiscounts,
      total: subtotal - productDiscounts,
      customerName: prefilledName,
      customerPhone: prefilledPhone,
      customerAddress: prefilledAddress,
      selectedGovernorateId: prefilledGovernorateId,
      addresses: cartState.addresses,
      selectedAddress: checkoutData?.selectedAddress,
      isLoadingGovernorates: true,
      isLoadingAddresses: cartState.addresses.isEmpty,
    ));

    // Fetch user data if not provided in cartState
    if (prefilledName.isEmpty || prefilledPhone.isEmpty) {
      final userResult = await _getUserDataUseCase();
      userResult.fold(
        (_) => null,
        (userData) {
          if (userData != null) {
            prefilledName = userData.name ?? prefilledName;
            prefilledPhone = userData.phone ?? prefilledPhone;
            emit(state.copyWith(
              customerName: prefilledName,
              customerPhone: prefilledPhone,
            ));
          }
        },
      );
    }

    // Fetch addresses if not provided in cartState
    if (cartState.addresses.isEmpty) {
      final addressesResult = await _getUserAddressesUseCase();
      addressesResult.fold(
        (_) => emit(state.copyWith(isLoadingAddresses: false)),
        (addresses) => emit(state.copyWith(
          addresses: addresses,
          isLoadingAddresses: false,
        )),
      );
    }

    final result = await _getGovernoratesUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: CheckoutStatus.error,
        errorMessage: failure.message,
        isLoadingGovernorates: false,
      )),
      (governorates) {
        double shippingFee = 0;
        if (prefilledGovernorateId != null) {
          final gov = governorates
              .where((g) => g.id == prefilledGovernorateId)
              .firstOrNull;
          shippingFee = gov?.shippingCost ?? 0.0;
        }

        final total =
            _calculateTotal(subtotal, productDiscounts, shippingFee, 0);

        emit(state.copyWith(
          status: CheckoutStatus.initial,
          governorates: governorates,
          isLoadingGovernorates: false,
          shippingFee: shippingFee,
          total: total,
        ));

        // Load centers if governorate is pre-selected
        if (prefilledGovernorateId != null) {
          add(CheckoutGovernorateSelected(prefilledGovernorateId));
        }
      },
    );
  }

  Future<void> _onGovernorateSelected(
    CheckoutGovernorateSelected event,
    Emitter<CheckoutState> emit,
  ) async {
    final gov = state.governorates
        .where((g) => g.id == event.governorateId)
        .firstOrNull;
    final shippingFee = gov?.shippingCost ?? 0.0;
    final total = _calculateTotal(state.subtotal, state.productDiscounts,
        shippingFee, state.discountAmount);

    emit(state.copyWith(
      selectedGovernorateId: event.governorateId,
      selectedCenterId: event.centerId,
      clearSelectedCenterId: event.centerId == null,
      centers: const [],
      shippingFee: shippingFee,
      total: total,
      isLoadingCenters: true,
      clearGovernorateError: true,
    ));

    final result =
        await _getCentersUseCase(GetCentersParams(event.governorateId));

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingCenters: false,
        errorMessage: failure.message,
      )),
      (centers) => emit(state.copyWith(
        centers: centers,
        isLoadingCenters: false,
        selectedCenterId: event.centerId ?? state.selectedCenterId,
      )),
    );
  }

  void _onCenterSelected(
    CheckoutCenterSelected event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(
      selectedCenterId: event.centerId,
      clearCenterError: true,
    ));
  }

  void _onFormChanged(
    CheckoutFormChanged event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(
      customerName: event.customerName ?? state.customerName,
      customerPhone: event.customerPhone ?? state.customerPhone,
      customerAddress: event.customerAddress ?? state.customerAddress,
      region: event.region ?? state.region,
      couponCode: event.couponCode ?? state.couponCode,
    ));
  }

  Future<void> _onCouponApplied(
    CheckoutCouponApplied event,
    Emitter<CheckoutState> emit,
  ) async {
    if (event.code.trim().isEmpty) return;

    emit(state.copyWith(
      isApplyingCoupon: true,
      clearCouponError: true,
    ));

    final result = await _applyCouponUseCase(event.code.trim());

    result.fold(
      (failure) => emit(state.copyWith(
        isApplyingCoupon: false,
        couponError: failure.message,
      )),
      (coupon) {
        final discount =
            _calculateDiscount(coupon, state.subtotal - state.productDiscounts);
        final total = _calculateTotal(state.subtotal, state.productDiscounts,
            state.shippingFee, discount);
        emit(state.copyWith(
          isApplyingCoupon: false,
          appliedCoupon: coupon,
          discountAmount: discount,
          total: total,
          clearCouponError: true,
        ));
      },
    );
  }

  void _onCouponRemoved(
    CheckoutCouponRemoved event,
    Emitter<CheckoutState> emit,
  ) {
    final total = _calculateTotal(
        state.subtotal, state.productDiscounts, state.shippingFee, 0);
    emit(state.copyWith(
      clearAppliedCoupon: true,
      discountAmount: 0,
      total: total,
      couponCode: '',
      clearCouponError: true,
    ));
  }

  Future<void> _onCheckoutSubmitted(
    CheckoutSubmitted event,
    Emitter<CheckoutState> emit,
  ) async {
    // Validate form
    final nameError = state.customerName.trim().isEmpty
        ? 'checkout_validation_name_required'
        : null;
    final phoneError = state.customerPhone.trim().isEmpty
        ? 'checkout_validation_phone_required'
        : null;
    final addressError = state.customerAddress.trim().isEmpty
        ? 'checkout_validation_address_required'
        : null;
    final governorateError = state.selectedGovernorateId == null
        ? 'checkout_validation_governorate_required'
        : null;
    final centerError = state.selectedCenterId == null
        ? 'checkout_validation_center_required'
        : null;

    if (nameError != null ||
        phoneError != null ||
        addressError != null ||
        governorateError != null ||
        centerError != null) {
      emit(state.copyWith(
        nameError: nameError,
        phoneError: phoneError,
        addressError: addressError,
        governorateError: governorateError,
        centerError: centerError,
      ));
      return;
    }

    emit(state.copyWith(status: CheckoutStatus.submitting));

    final params = PlaceOrderParams(
      customerName: state.customerName.trim(),
      customerPhone: state.customerPhone.trim(),
      customerAddress: state.customerAddress.trim(),
      governorateId: state.selectedGovernorateId!,
      region: state.region.trim(),
      centerId: state.selectedCenterId!,
      couponCode: state.appliedCoupon?.code,
      items: state.items,
    );

    final result = await _placeOrderUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(
        status: CheckoutStatus.error,
        errorMessage: failure.message,
      )),
      (order) {
        _ordersBloc.add(const GetOrdersEvent());
        emit(state.copyWith(
          status: CheckoutStatus.success,
          placedOrder: order,
        ));
      },
    );
  }

  Future<void> _onAddressSelected(
    CheckoutAddressSelected event,
    Emitter<CheckoutState> emit,
  ) async {
    final address = event.address;

    emit(state.copyWith(
      selectedAddress: address,
      customerAddress: address.address,
      region: address.title,
      selectedGovernorateId: address.governorateId,
      selectedCenterId: address.centerId,
      clearGovernorateError: true,
      clearCenterError: true,
      clearAddressError: true,
    ));

    // Load centers for the new governorate and set the center
    add(CheckoutGovernorateSelected(address.governorateId,
        centerId: address.centerId));
  }

  Future<void> _onAddressesRefreshed(
    CheckoutAddressesRefreshed event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(isLoadingAddresses: true));
    final addressesResult = await _getUserAddressesUseCase();
    addressesResult.fold(
      (_) => emit(state.copyWith(isLoadingAddresses: false)),
      (addresses) {
        emit(state.copyWith(
          addresses: addresses,
          isLoadingAddresses: false,
        ));
        // If a new address was just added, it's likely the last one in the list
        // or we could just select the first one if none is selected
        if (addresses.isNotEmpty && state.selectedAddress == null) {
          add(CheckoutAddressSelected(addresses.first));
        }
      },
    );
  }
}
