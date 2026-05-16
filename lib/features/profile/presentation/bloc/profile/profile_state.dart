part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final AppStatus status;
  final AppStatus actionStatus;
  final AppStatus addressStatus;
  final AppStatus governorateStatus;
  final AppStatus centerStatus;
  final UserEntity? user;
  final List<AddressEntity> addresses;
  final List<GovernorateEntity> governorates;
  final List<CenterEntity> centers;
  final String? errorMessage;
  final String? actionError;
  final String? addressError;
  final String? governorateError;
  final String? centerError;

  const ProfileState({
    this.status = AppStatus.initial,
    this.actionStatus = AppStatus.initial,
    this.addressStatus = AppStatus.initial,
    this.governorateStatus = AppStatus.initial,
    this.centerStatus = AppStatus.initial,
    this.user,
    this.addresses = const [],
    this.governorates = const [],
    this.centers = const [],
    this.errorMessage,
    this.actionError,
    this.addressError,
    this.governorateError,
    this.centerError,
  });

  ProfileState copyWith({
    AppStatus? status,
    AppStatus? actionStatus,
    AppStatus? addressStatus,
    AppStatus? governorateStatus,
    AppStatus? centerStatus,
    UserEntity? user,
    List<AddressEntity>? addresses,
    List<GovernorateEntity>? governorates,
    List<CenterEntity>? centers,
    String? errorMessage,
    String? actionError,
    String? addressError,
    String? governorateError,
    String? centerError,
    bool clearError = false,
    bool clearActionError = false,
    bool clearAddressError = false,
    bool clearGovernorateError = false,
    bool clearCenterError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      addressStatus: addressStatus ?? this.addressStatus,
      governorateStatus: governorateStatus ?? this.governorateStatus,
      centerStatus: centerStatus ?? this.centerStatus,
      user: user ?? this.user,
      addresses: addresses ?? this.addresses,
      governorates: governorates ?? this.governorates,
      centers: centers ?? this.centers,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      actionError: clearActionError ? null : (actionError ?? this.actionError),
      addressError:
          clearAddressError ? null : (addressError ?? this.addressError),
      governorateError: clearGovernorateError
          ? null
          : (governorateError ?? this.governorateError),
      centerError: clearCenterError ? null : (centerError ?? this.centerError),
    );
  }

  @override
  List<Object?> get props => [
        status,
        actionStatus,
        addressStatus,
        governorateStatus,
        centerStatus,
        user,
        addresses,
        governorates,
        centers,
        errorMessage,
        actionError,
        addressError,
        governorateError,
        centerError,
      ];
}
