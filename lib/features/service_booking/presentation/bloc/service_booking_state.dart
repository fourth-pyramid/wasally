part of 'service_booking_bloc.dart';

enum ServiceBookingStatus { initial, loading, submitting, success, error }

class ServiceBookingState extends Equatable {
  final ServiceBookingStatus status;
  final ServiceDetailEntity? service;
  final ServiceAvailableDayEntity? selectedDay;
  final ServiceAvailableTimeEntity? selectedTime;

  // Form fields
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String problemDescription;

  // Address lookup
  final List<GovernorateEntity> governorates;
  final List<CenterEntity> centers;
  final List<AddressEntity> addresses;
  final AddressEntity? selectedAddress;
  final String? selectedGovernorateId;
  final String? selectedCenterId;
  final bool isLoadingGovernorates;
  final bool isLoadingCenters;
  final bool isLoadingAddresses;

  // Result
  final BookingEntity? booking;
  final String? errorMessage;

  // Validation errors
  final String? nameError;
  final String? phoneError;
  final String? emailError;
  final String? dayError;
  final String? timeError;
  final String? governorateError;
  final String? centerError;

  const ServiceBookingState({
    this.status = ServiceBookingStatus.initial,
    this.service,
    this.selectedDay,
    this.selectedTime,
    this.customerName = '',
    this.customerPhone = '',
    this.customerEmail = '',
    this.problemDescription = '',
    this.governorates = const [],
    this.centers = const [],
    this.addresses = const [],
    this.selectedAddress,
    this.selectedGovernorateId,
    this.selectedCenterId,
    this.isLoadingGovernorates = false,
    this.isLoadingCenters = false,
    this.isLoadingAddresses = false,
    this.booking,
    this.errorMessage,
    this.nameError,
    this.phoneError,
    this.emailError,
    this.dayError,
    this.timeError,
    this.governorateError,
    this.centerError,
  });

  ServiceBookingState copyWith({
    ServiceBookingStatus? status,
    ServiceDetailEntity? service,
    ServiceAvailableDayEntity? selectedDay,
    bool clearSelectedDay = false,
    ServiceAvailableTimeEntity? selectedTime,
    bool clearSelectedTime = false,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? problemDescription,
    List<GovernorateEntity>? governorates,
    List<CenterEntity>? centers,
    List<AddressEntity>? addresses,
    AddressEntity? selectedAddress,
    bool clearSelectedAddress = false,
    String? selectedGovernorateId,
    bool clearSelectedGovernorateId = false,
    String? selectedCenterId,
    bool clearSelectedCenterId = false,
    bool? isLoadingGovernorates,
    bool? isLoadingCenters,
    bool? isLoadingAddresses,
    BookingEntity? booking,
    String? errorMessage,
    String? nameError,
    bool clearNameError = false,
    String? phoneError,
    bool clearPhoneError = false,
    String? emailError,
    bool clearEmailError = false,
    String? dayError,
    bool clearDayError = false,
    String? timeError,
    bool clearTimeError = false,
    String? governorateError,
    bool clearGovernorateError = false,
    String? centerError,
    bool clearCenterError = false,
  }) {
    return ServiceBookingState(
      status: status ?? this.status,
      service: service ?? this.service,
      selectedDay: clearSelectedDay ? null : selectedDay ?? this.selectedDay,
      selectedTime:
          clearSelectedTime ? null : selectedTime ?? this.selectedTime,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      problemDescription: problemDescription ?? this.problemDescription,
      governorates: governorates ?? this.governorates,
      centers: centers ?? this.centers,
      addresses: addresses ?? this.addresses,
      selectedAddress:
          clearSelectedAddress ? null : selectedAddress ?? this.selectedAddress,
      selectedGovernorateId: clearSelectedGovernorateId
          ? null
          : selectedGovernorateId ?? this.selectedGovernorateId,
      selectedCenterId: clearSelectedCenterId
          ? null
          : selectedCenterId ?? this.selectedCenterId,
      isLoadingGovernorates:
          isLoadingGovernorates ?? this.isLoadingGovernorates,
      isLoadingCenters: isLoadingCenters ?? this.isLoadingCenters,
      isLoadingAddresses: isLoadingAddresses ?? this.isLoadingAddresses,
      booking: booking ?? this.booking,
      errorMessage: errorMessage ?? this.errorMessage,
      nameError: clearNameError ? null : nameError ?? this.nameError,
      phoneError: clearPhoneError ? null : phoneError ?? this.phoneError,
      emailError: clearEmailError ? null : emailError ?? this.emailError,
      dayError: clearDayError ? null : dayError ?? this.dayError,
      timeError: clearTimeError ? null : timeError ?? this.timeError,
      governorateError: clearGovernorateError
          ? null
          : governorateError ?? this.governorateError,
      centerError: clearCenterError ? null : centerError ?? this.centerError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        service,
        selectedDay,
        selectedTime,
        customerName,
        customerPhone,
        customerEmail,
        problemDescription,
        governorates,
        centers,
        addresses,
        selectedAddress,
        selectedGovernorateId,
        selectedCenterId,
        isLoadingGovernorates,
        isLoadingCenters,
        isLoadingAddresses,
        booking,
        errorMessage,
        nameError,
        phoneError,
        emailError,
        dayError,
        timeError,
        governorateError,
        centerError,
      ];
}
