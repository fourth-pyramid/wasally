import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_event.dart';

import '../../../../features/cart/domain/usecases/get_user_addresses_usecase.dart';
import '../../../../features/cart/domain/usecases/get_user_data_usecase.dart';
import '../../../../features/profile/domain/entities/address_entity.dart';
import '../../../../features/profile/domain/entities/center_entity.dart';
import '../../../../features/profile/domain/entities/governorate_entity.dart';
import '../../../../features/profile/domain/usecases/get_centers_usecase.dart';
import '../../../../features/profile/domain/usecases/get_governorates_usecase.dart';
import '../../../service_details/domain/entities/service_detail_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/create_booking_usecase.dart';

part 'service_booking_event.dart';
part 'service_booking_state.dart';

class ServiceBookingBloc
    extends Bloc<ServiceBookingEvent, ServiceBookingState> {
  final CreateBookingUseCase _createBookingUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCentersUseCase _getCentersUseCase;
  final GetUserDataUseCase _getUserDataUseCase;
  final GetUserAddressesUseCase _getUserAddressesUseCase;

  final OrdersBloc _ordersBloc;

  ServiceBookingBloc({
    required CreateBookingUseCase createBookingUseCase,
    required GetGovernoratesUseCase getGovernoratesUseCase,
    required GetCentersUseCase getCentersUseCase,
    required GetUserDataUseCase getUserDataUseCase,
    required GetUserAddressesUseCase getUserAddressesUseCase,
    required OrdersBloc ordersBloc,
  })  : _createBookingUseCase = createBookingUseCase,
        _getGovernoratesUseCase = getGovernoratesUseCase,
        _getCentersUseCase = getCentersUseCase,
        _getUserDataUseCase = getUserDataUseCase,
        _getUserAddressesUseCase = getUserAddressesUseCase,
        _ordersBloc = ordersBloc,
        super(const ServiceBookingState()) {
    on<ServiceBookingInitialized>(_onInitialized);
    on<ServiceBookingDaySelected>(_onDaySelected);
    on<ServiceBookingTimeSelected>(_onTimeSelected);
    on<ServiceBookingGovernorateSelected>(_onGovernorateSelected);
    on<ServiceBookingCenterSelected>(_onCenterSelected);
    on<ServiceBookingFormChanged>(_onFormChanged);
    on<ServiceBookingSubmitted>(_onSubmitted);
    on<ServiceBookingAddressSelected>(_onAddressSelected);
    on<ServiceBookingAddressesRefreshed>(_onAddressesRefreshed);
  }

  Future<void> _onInitialized(
    ServiceBookingInitialized event,
    Emitter<ServiceBookingState> emit,
  ) async {
    emit(state.copyWith(
      status: ServiceBookingStatus.loading,
      service: event.service,
      selectedDay: event.preselectedDay,
      selectedTime: event.preselectedTime,
      isLoadingGovernorates: true,
      isLoadingAddresses: true,
    ));

    // Fetch user data for pre-filling
    final userResult = await _getUserDataUseCase();
    userResult.fold(
      (_) => null,
      (user) {
        if (user != null) {
          emit(state.copyWith(
            customerName: user.name ?? '',
            customerPhone: user.phone ?? '',
            customerEmail: user.email,
          ));
        }
      },
    );

    // Fetch addresses for pre-filling
    final addressesResult = await _getUserAddressesUseCase();
    addressesResult.fold(
      (_) => emit(state.copyWith(isLoadingAddresses: false)),
      (addresses) {
        emit(state.copyWith(
          addresses: addresses,
          isLoadingAddresses: false,
        ));
        if (addresses.isNotEmpty) {
          add(ServiceBookingAddressSelected(addresses.first));
        }
      },
    );

    // Fetch governorates
    final govResult = await _getGovernoratesUseCase();
    govResult.fold(
      (failure) => emit(state.copyWith(
        status: ServiceBookingStatus.error,
        errorMessage: failure.message,
        isLoadingGovernorates: false,
      )),
      (governorates) => emit(state.copyWith(
        status: ServiceBookingStatus.initial,
        governorates: governorates,
        isLoadingGovernorates: false,
      )),
    );
  }

  void _onDaySelected(
    ServiceBookingDaySelected event,
    Emitter<ServiceBookingState> emit,
  ) {
    emit(state.copyWith(
      selectedDay: event.day,
      clearSelectedTime: true,
      clearDayError: true,
    ));
  }

  void _onTimeSelected(
    ServiceBookingTimeSelected event,
    Emitter<ServiceBookingState> emit,
  ) {
    emit(state.copyWith(
      selectedTime: event.time,
      clearTimeError: true,
    ));
  }

  Future<void> _onGovernorateSelected(
    ServiceBookingGovernorateSelected event,
    Emitter<ServiceBookingState> emit,
  ) async {
    emit(state.copyWith(
      selectedGovernorateId: event.governorateId,
      selectedCenterId: event.centerId,
      clearSelectedCenterId: event.centerId == null,
      centers: const [],
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
    ServiceBookingCenterSelected event,
    Emitter<ServiceBookingState> emit,
  ) {
    emit(state.copyWith(
      selectedCenterId: event.centerId,
      clearCenterError: true,
    ));
  }

  Future<void> _onAddressSelected(
    ServiceBookingAddressSelected event,
    Emitter<ServiceBookingState> emit,
  ) async {
    final address = event.address;
    emit(state.copyWith(
      selectedAddress: address,
      selectedGovernorateId: address.governorateId,
      selectedCenterId: address.centerId,
      clearGovernorateError: true,
      clearCenterError: true,
    ));

    // Load centers for the pre-selected governorate
    add(ServiceBookingGovernorateSelected(address.governorateId,
        centerId: address.centerId));
  }

  Future<void> _onAddressesRefreshed(
    ServiceBookingAddressesRefreshed event,
    Emitter<ServiceBookingState> emit,
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
        if (addresses.isNotEmpty && state.selectedAddress == null) {
          add(ServiceBookingAddressSelected(addresses.first));
        }
      },
    );
  }

  void _onFormChanged(
    ServiceBookingFormChanged event,
    Emitter<ServiceBookingState> emit,
  ) {
    emit(state.copyWith(
      customerName: event.name ?? state.customerName,
      customerPhone: event.phone ?? state.customerPhone,
      customerEmail: event.email ?? state.customerEmail,
      problemDescription: event.problemDescription ?? state.problemDescription,
      clearNameError: event.name != null,
      clearPhoneError: event.phone != null,
      clearEmailError: event.email != null,
    ));
  }

  Future<void> _onSubmitted(
    ServiceBookingSubmitted event,
    Emitter<ServiceBookingState> emit,
  ) async {
    // Basic validation
    final nameError = state.customerName.trim().isEmpty ? 'الاسم مطلوب' : null;
    final phoneError =
        state.customerPhone.trim().isEmpty ? 'رقم الهاتف مطلوب' : null;
    final dayError = state.selectedDay == null ? 'يرجى اختيار اليوم' : null;
    final timeError = state.selectedTime == null ? 'يرجى اختيار الوقت' : null;
    final governorateError =
        state.selectedGovernorateId == null ? 'المحافظة مطلوبة' : null;
    final centerError = state.selectedCenterId == null ? 'المركز مطلوب' : null;

    if (nameError != null ||
        phoneError != null ||
        dayError != null ||
        timeError != null ||
        governorateError != null ||
        centerError != null) {
      emit(state.copyWith(
        nameError: nameError,
        phoneError: phoneError,
        dayError: dayError,
        timeError: timeError,
        governorateError: governorateError,
        centerError: centerError,
      ));
      return;
    }

    emit(state.copyWith(status: ServiceBookingStatus.submitting));

    final params = BookingParams(
      serviceId: state.service!.id,
      availableDayId: state.selectedDay!.id,
      availableTimeId: state.selectedTime!.id,
      problemDescription: state.problemDescription,
      customerName: state.customerName,
      customerPhone: state.customerPhone,
      customerEmail: state.customerEmail,
      governorateId: state.selectedGovernorateId!,
      centerId: state.selectedCenterId!,
    );

    final result = await _createBookingUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ServiceBookingStatus.error,
        errorMessage: failure.message,
      )),
      (booking) {
        _ordersBloc.add(const GetServiceBookingsEvent());
        emit(state.copyWith(
          status: ServiceBookingStatus.success,
          booking: booking,
        ));
      },
    );
  }
}
