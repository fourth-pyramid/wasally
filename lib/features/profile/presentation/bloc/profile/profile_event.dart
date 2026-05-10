part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileFetched extends ProfileEvent {
  const ProfileFetched();
}

class ProfileRefreshRequested extends ProfileEvent {
  const ProfileRefreshRequested();
}

class ProfileUpdated extends ProfileEvent {
  final String fullName;
  final String phone;
  final File? avatar;
  final String? password;
  final String? currentPassword;
  final String? passwordConfirmation;

  const ProfileUpdated({
    required this.fullName,
    required this.phone,
    this.avatar,
    this.password,
    this.currentPassword,
    this.passwordConfirmation,
  });

  @override
  List<Object?> get props => [
        fullName,
        phone,
        avatar,
        password,
        currentPassword,
        passwordConfirmation,
      ];
}

class ProfileLoggedOut extends ProfileEvent {
  const ProfileLoggedOut();
}

class ProfileLoggedOutAllDevices extends ProfileEvent {
  const ProfileLoggedOutAllDevices();
}

class ProfileAccountDeleted extends ProfileEvent {
  const ProfileAccountDeleted();
}

class AddressesFetched extends ProfileEvent {
  const AddressesFetched();
}

class AddressCreated extends ProfileEvent {
  final String title;
  final String address;
  final String governorateId;
  final String centerId;

  const AddressCreated({
    required this.title,
    required this.address,
    required this.governorateId,
    required this.centerId,
  });

  @override
  List<Object?> get props => [title, address, governorateId, centerId];
}

class AddressUpdated extends ProfileEvent {
  final String addressId;
  final String title;
  final String address;
  final String governorateId;
  final String centerId;

  const AddressUpdated({
    required this.addressId,
    required this.title,
    required this.address,
    required this.governorateId,
    required this.centerId,
  });

  @override
  List<Object?> get props =>
      [addressId, title, address, governorateId, centerId];
}

class AddressDeleted extends ProfileEvent {
  final String addressId;

  const AddressDeleted({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}

class GovernoratesFetched extends ProfileEvent {
  const GovernoratesFetched();
}

class CentersFetched extends ProfileEvent {
  final String governorateId;

  const CentersFetched(this.governorateId);

  @override
  List<Object?> get props => [governorateId];
}
