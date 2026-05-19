import 'package:wassaly/core/imports/imports.dart';
import '../../domain/entities/service_detail_entity.dart';
import '../../domain/usecases/get_service_details_usecase.dart';
import '../../domain/usecases/toggle_service_favorite_usecase.dart';
import '../../domain/usecases/create_service_review_usecase.dart';
import '../../domain/usecases/update_service_review_usecase.dart';

part 'service_details_event.dart';
part 'service_details_state.dart';

class ServiceDetailsBloc
    extends Bloc<ServiceDetailsEvent, ServiceDetailsState> {
  final GetServiceDetailsUseCase _getServiceDetailsUseCase;
  final ToggleServiceFavoriteUseCase _toggleServiceFavoriteUseCase;
  final CreateServiceReviewUseCase _createServiceReviewUseCase;
  final UpdateServiceReviewUseCase _updateServiceReviewUseCase;

  ServiceDetailsBloc({
    required GetServiceDetailsUseCase getServiceDetailsUseCase,
    required ToggleServiceFavoriteUseCase toggleServiceFavoriteUseCase,
    required CreateServiceReviewUseCase createServiceReviewUseCase,
    required UpdateServiceReviewUseCase updateServiceReviewUseCase,
  })  : _getServiceDetailsUseCase = getServiceDetailsUseCase,
        _toggleServiceFavoriteUseCase = toggleServiceFavoriteUseCase,
        _createServiceReviewUseCase = createServiceReviewUseCase,
        _updateServiceReviewUseCase = updateServiceReviewUseCase,
        super(const ServiceDetailsState()) {
    on<FetchServiceDetailsEvent>(_onFetchServiceDetails);
    on<ToggleServiceFavoriteEvent>(_onToggleServiceFavorite);
    on<CreateServiceReviewEvent>(_onCreateServiceReview);
    on<UpdateServiceReviewEvent>(_onUpdateServiceReview);
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

  Future<void> _onCreateServiceReview(
    CreateServiceReviewEvent event,
    Emitter<ServiceDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        reviewActionStatus: ReviewActionStatus.loading,
        reviewActionMessage: '',
      ),
    );

    final result = await _createServiceReviewUseCase(
      CreateServiceReviewParams(
        serviceId: event.serviceId,
        rating: event.rating,
        comment: event.comment,
      ),
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            reviewActionStatus: ReviewActionStatus.failure,
            reviewActionMessage: failure.message,
          ),
        );
      },
      (_) async {
        await _refreshServiceAfterReviewAction(
          serviceId: event.serviceId,
          emit: emit,
          successMessage: 'product_details_review_created',
        );
      },
    );
  }

  Future<void> _onUpdateServiceReview(
    UpdateServiceReviewEvent event,
    Emitter<ServiceDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        reviewActionStatus: ReviewActionStatus.loading,
        reviewActionMessage: '',
      ),
    );

    final result = await _updateServiceReviewUseCase(
      UpdateServiceReviewParams(
        reviewId: event.reviewId,
        rating: event.rating,
        comment: event.comment,
      ),
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            reviewActionStatus: ReviewActionStatus.failure,
            reviewActionMessage: failure.message,
          ),
        );
      },
      (_) async {
        if (state.service != null) {
          await _refreshServiceAfterReviewAction(
            serviceId: state.service!.id,
            emit: emit,
            successMessage: 'product_details_review_updated',
          );
        }
      },
    );
  }

  Future<void> _refreshServiceAfterReviewAction({
    required int serviceId,
    required Emitter<ServiceDetailsState> emit,
    required String successMessage,
  }) async {
    final refreshed = await _getServiceDetailsUseCase(serviceId);

    refreshed.fold(
      (failure) => emit(
        state.copyWith(
          reviewActionStatus: ReviewActionStatus.failure,
          reviewActionMessage: failure.message,
        ),
      ),
      (service) => emit(
        state.copyWith(
          status: ServiceDetailsStatus.success,
          service: service,
          reviewActionStatus: ReviewActionStatus.success,
          reviewActionMessage: successMessage,
        ),
      ),
    );
  }
}
