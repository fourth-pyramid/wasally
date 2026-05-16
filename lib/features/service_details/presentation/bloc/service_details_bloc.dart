import 'package:wassaly/core/imports/imports.dart';
import '../../domain/entities/service_detail_entity.dart';
import '../../domain/usecases/get_service_details_usecase.dart';
import '../../domain/usecases/toggle_service_favorite_usecase.dart';

part 'service_details_event.dart';
part 'service_details_state.dart';

class ServiceDetailsBloc
    extends Bloc<ServiceDetailsEvent, ServiceDetailsState> {
  final GetServiceDetailsUseCase _getServiceDetailsUseCase;
  final ToggleServiceFavoriteUseCase _toggleServiceFavoriteUseCase;

  ServiceDetailsBloc({
    required GetServiceDetailsUseCase getServiceDetailsUseCase,
    required ToggleServiceFavoriteUseCase toggleServiceFavoriteUseCase,
  })  : _getServiceDetailsUseCase = getServiceDetailsUseCase,
        _toggleServiceFavoriteUseCase = toggleServiceFavoriteUseCase,
        super(const ServiceDetailsState()) {
    on<FetchServiceDetailsEvent>(_onFetchServiceDetails);
    on<ToggleServiceFavoriteEvent>(_onToggleServiceFavorite);
  }

  Future<void> _onFetchServiceDetails(
    FetchServiceDetailsEvent event,
    Emitter<ServiceDetailsState> emit,
  ) async {
    emit(state.copyWith(status: ServiceDetailsStatus.loading));

    final result = await _getServiceDetailsUseCase(event.serviceId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ServiceDetailsStatus.failure,
        errorMessage: failure.message,
      )),
      (service) => emit(state.copyWith(
        status: ServiceDetailsStatus.success,
        service: service,
      )),
    );
  }

  Future<void> _onToggleServiceFavorite(
    ToggleServiceFavoriteEvent event,
    Emitter<ServiceDetailsState> emit,
  ) async {
    if (state.service == null) return;

    emit(state.copyWith(isFavoriteLoading: true));

    final result = await _toggleServiceFavoriteUseCase(
      event.serviceId,
      state.service!.isFavorite,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isFavoriteLoading: false,
        errorMessage: failure.message,
      )),
      (isFavorite) => emit(state.copyWith(
        isFavoriteLoading: false,
        service: state.service!.copyWith(isFavorite: isFavorite),
      )),
    );
  }
}
