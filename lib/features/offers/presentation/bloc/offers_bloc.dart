import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/offers/domain/usecases/get_offers_use_case.dart';
import 'package:wassaly/features/offers/presentation/bloc/offers_event.dart';
import 'package:wassaly/features/offers/presentation/bloc/offers_state.dart';

class OffersBloc extends Bloc<OffersEvent, OffersState> {
  final GetOffersUseCase _getOffersUseCase;

  OffersBloc(this._getOffersUseCase) : super(const OffersState()) {
    on<GetOffersEvent>(_onGetOffers);
    on<LoadMoreOffersEvent>(_onLoadMoreOffers);
  }

  Future<void> _onGetOffers(
    GetOffersEvent event,
    Emitter<OffersState> emit,
  ) async {
    emit(state.copyWith(status: AppStatus.loading, currentPage: 1));

    final result = await _getOffersUseCase(1);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: AppStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (response) {
        emit(state.copyWith(
          status: AppStatus.success,
          products: response.data,
          currentPage: response.currentPage,
          hasReachedMax: response.currentPage >= response.lastPage,
        ));
      },
    );
  }

  Future<void> _onLoadMoreOffers(
    LoadMoreOffersEvent event,
    Emitter<OffersState> emit,
  ) async {
    if (state.hasReachedMax ||
        state.status == AppStatus.loading ||
        state.isLoadingMore) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;
    final result = await _getOffersUseCase(nextPage);

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        ));
      },
      (response) {
        emit(state.copyWith(
          isLoadingMore: false,
          products: List.of(state.products)..addAll(response.data),
          currentPage: response.currentPage,
          hasReachedMax: response.currentPage >= response.lastPage,
        ));
      },
    );
  }
}
