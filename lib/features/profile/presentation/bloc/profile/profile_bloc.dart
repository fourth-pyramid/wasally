import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/logout_usecase.dart'
    as auth;
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:wassaly/features/profile/domain/entities/address_entity.dart';
import 'package:wassaly/features/profile/domain/entities/center_entity.dart';
import 'package:wassaly/features/profile/domain/entities/governorate_entity.dart';
import 'package:wassaly/features/profile/domain/usecases/create_address_usecase.dart';
import 'package:wassaly/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:wassaly/features/profile/domain/usecases/delete_address_usecase.dart';
import 'package:wassaly/features/profile/domain/usecases/get_addresses_usecase.dart';
import 'package:wassaly/features/profile/domain/usecases/get_centers_usecase.dart';
import 'package:wassaly/features/profile/domain/usecases/get_governorates_usecase.dart';
import 'package:wassaly/features/profile/domain/usecases/logout_all_devices_usecase.dart';
import 'package:wassaly/features/profile/domain/usecases/update_address_usecase.dart';
import 'package:wassaly/features/profile/domain/usecases/update_profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCachedUserUseCase _getCachedUserUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final auth.LogoutUseCase _logoutUseCase;
  final LogoutAllDevicesUseCase _logoutAllDevicesUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final GetAddressesUseCase _getAddressesUseCase;
  final CreateAddressUseCase _createAddressUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCentersUseCase _getCentersUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;
  final SessionBloc _sessionBloc;

  ProfileBloc({
    required GetCachedUserUseCase getCachedUserUseCase,
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required auth.LogoutUseCase logoutUseCase,
    required LogoutAllDevicesUseCase logoutAllDevicesUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required GetAddressesUseCase getAddressesUseCase,
    required CreateAddressUseCase createAddressUseCase,
    required GetGovernoratesUseCase getGovernoratesUseCase,
    required GetCentersUseCase getCentersUseCase,
    required UpdateAddressUseCase updateAddressUseCase,
    required DeleteAddressUseCase deleteAddressUseCase,
    required SessionBloc sessionBloc,
  })  : _getCachedUserUseCase = getCachedUserUseCase,
        _getProfileUseCase = getProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _logoutUseCase = logoutUseCase,
        _logoutAllDevicesUseCase = logoutAllDevicesUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _getAddressesUseCase = getAddressesUseCase,
        _createAddressUseCase = createAddressUseCase,
        _getGovernoratesUseCase = getGovernoratesUseCase,
        _getCentersUseCase = getCentersUseCase,
        _updateAddressUseCase = updateAddressUseCase,
        _deleteAddressUseCase = deleteAddressUseCase,
        _sessionBloc = sessionBloc,
        super(const ProfileState()) {
    on<ProfileFetched>(_onProfileFetched);
    on<ProfileRefreshRequested>(_onProfileRefreshRequested);
    on<ProfileUpdated>(_onProfileUpdated);
    on<ProfileLoggedOut>(_onProfileLoggedOut);
    on<ProfileLoggedOutAllDevices>(_onProfileLoggedOutAllDevices);
    on<ProfileAccountDeleted>(_onProfileAccountDeleted);
    on<AddressesFetched>(_onAddressesFetched);
    on<AddressCreated>(_onAddressCreated);
    on<AddressUpdated>(_onAddressUpdated);
    on<AddressDeleted>(_onAddressDeleted);
    on<GovernoratesFetched>(_onGovernoratesFetched);
    on<CentersFetched>(_onCentersFetched);
  }

  Future<void> _onProfileFetched(
    ProfileFetched event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: AppStatus.loading));

    final result = await _getCachedUserUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: AppStatus.failure,
        errorMessage: failure.message,
      )),
      (user) {
        if (user != null) {
          emit(state.copyWith(
            status: AppStatus.success,
            user: user,
            clearError: true,
          ));
        } else {
          emit(state.copyWith(
            status: AppStatus.failure,
            errorMessage: 'no_cached_user'.tr(),
          ));
        }
      },
    );
  }

  /// Background refresh - fetches from API and updates cache silently
  /// Does NOT show loading state to avoid UI flicker
  Future<void> _onProfileRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await _getProfileUseCase();

    result.fold(
      (failure) {
        // Silently fail - don't update error state for background refresh
        // If token is invalid, SessionBloc will handle logout
        AppLogger.warning(
            'Background profile refresh failed: ${failure.message}');
      },
      (user) {
        // Update user silently - UI will reflect changes
        emit(state.copyWith(
          user: user,
          clearError: true,
        ));
      },
    );
  }

  Future<void> _onProfileUpdated(
    ProfileUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(actionStatus: AppStatus.loading));

    final result = await _updateProfileUseCase(
      UpdateProfileParams(
        fullName: event.fullName,
        phone: event.phone,
        avatar: event.avatar,
        password: event.password,
        currentPassword: event.currentPassword,
        passwordConfirmation: event.passwordConfirmation,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        actionStatus: AppStatus.failure,
        actionError: failure.message,
      )),
      (user) => emit(state.copyWith(
        actionStatus: AppStatus.success,
        user: user,
        clearActionError: true,
      )),
    );
  }

  Future<void> _onProfileLoggedOut(
    ProfileLoggedOut event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(actionStatus: AppStatus.loading));

    final result = await _logoutUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        actionStatus: AppStatus.failure,
        actionError: failure.message,
      )),
      (_) => emit(state.copyWith(
        actionStatus: AppStatus.success,
        user: null,
        clearActionError: true,
      )),
    );
  }

  Future<void> _onProfileLoggedOutAllDevices(
    ProfileLoggedOutAllDevices event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(actionStatus: AppStatus.loading));

    final result = await _logoutAllDevicesUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        actionStatus: AppStatus.failure,
        actionError: failure.message,
      )),
      (_) {
        emit(state.copyWith(
          actionStatus: AppStatus.success,
          user: null,
          clearActionError: true,
        ));
        // Trigger session logout for navigation
        _sessionBloc.add(const SessionLogoutRequested());
      },
    );
  }

  Future<void> _onProfileAccountDeleted(
    ProfileAccountDeleted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(actionStatus: AppStatus.loading));

    final result = await _deleteAccountUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        actionStatus: AppStatus.failure,
        actionError: failure.message,
      )),
      (_) => emit(state.copyWith(
        actionStatus: AppStatus.success,
        user: null,
        clearActionError: true,
      )),
    );
  }

  Future<void> _onAddressesFetched(
    AddressesFetched event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(addressStatus: AppStatus.loading));

    final result = await _getAddressesUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        addressStatus: AppStatus.failure,
        addressError: failure.message,
      )),
      (addresses) => emit(state.copyWith(
        addressStatus: AppStatus.success,
        addresses: addresses,
        clearAddressError: true,
      )),
    );
  }

  Future<void> _onAddressCreated(
    AddressCreated event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(addressStatus: AppStatus.loading));

    final result = await _createAddressUseCase(
      CreateAddressParams(
        title: event.title,
        address: event.address,
        governorateId: event.governorateId,
        centerId: event.centerId,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        addressStatus: AppStatus.failure,
        addressError: failure.message,
      )),
      (address) {
        final updatedAddresses = List<AddressEntity>.from(state.addresses)
          ..add(address);
        emit(state.copyWith(
          addressStatus: AppStatus.success,
          addresses: updatedAddresses,
          clearAddressError: true,
        ));
      },
    );
  }

  Future<void> _onAddressUpdated(
    AddressUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(addressStatus: AppStatus.loading));

    final result = await _updateAddressUseCase(
      UpdateAddressParams(
        addressId: event.addressId,
        title: event.title,
        address: event.address,
        governorateId: event.governorateId,
        centerId: event.centerId,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        addressStatus: AppStatus.failure,
        addressError: failure.message,
      )),
      (updatedAddress) {
        final updatedAddresses = state.addresses
            .map((a) => a.id == updatedAddress.id ? updatedAddress : a)
            .toList();
        emit(state.copyWith(
          addressStatus: AppStatus.success,
          addresses: updatedAddresses,
          clearAddressError: true,
        ));
      },
    );
  }

  Future<void> _onAddressDeleted(
    AddressDeleted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(addressStatus: AppStatus.loading));

    final result = await _deleteAddressUseCase(
      DeleteAddressParams(addressId: event.addressId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        addressStatus: AppStatus.failure,
        addressError: failure.message,
      )),
      (_) {
        final updatedAddresses =
            state.addresses.where((a) => a.id != event.addressId).toList();
        emit(state.copyWith(
          addressStatus: AppStatus.success,
          addresses: updatedAddresses,
          clearAddressError: true,
        ));
      },
    );
  }

  Future<void> _onGovernoratesFetched(
    GovernoratesFetched event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(governorateStatus: AppStatus.loading));

    final result = await _getGovernoratesUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        governorateStatus: AppStatus.failure,
        governorateError: failure.message,
      )),
      (governorates) => emit(state.copyWith(
        governorateStatus: AppStatus.success,
        governorates: governorates,
        clearGovernorateError: true,
      )),
    );
  }

  Future<void> _onCentersFetched(
    CentersFetched event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(centerStatus: AppStatus.loading));

    final result = await _getCentersUseCase(
      GetCentersParams(event.governorateId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        centerStatus: AppStatus.failure,
        centerError: failure.message,
      )),
      (centers) => emit(state.copyWith(
        centerStatus: AppStatus.success,
        centers: centers,
        clearCenterError: true,
      )),
    );
  }
}
