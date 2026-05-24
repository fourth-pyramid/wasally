import 'package:wassaly/core/imports/imports.dart';
import '../../domain/entities/provider_detail_entity.dart';
import '../../domain/usecases/get_provider_details_usecase.dart';
import 'provider_details_event.dart';
import 'provider_details_state.dart';

class ProviderDetailsBloc
    extends Bloc<ProviderDetailsEvent, ProviderDetailsState> {
  final GetProviderDetailsUseCase _getProviderDetailsUseCase;

  ProviderDetailsBloc({
    required GetProviderDetailsUseCase getProviderDetailsUseCase,
  })  : _getProviderDetailsUseCase = getProviderDetailsUseCase,
        super(const ProviderDetailsState()) {
    on<FetchProviderDetailsEvent>(_onFetchProviderDetails);
  }

  Future<void> _onFetchProviderDetails(
    FetchProviderDetailsEvent event,
    Emitter<ProviderDetailsState> emit,
  ) async {
    emit(state.copyWith(status: AppStatus.loading));

    final result = await _getProviderDetailsUseCase(event.providerId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AppStatus.failure,
        errorMessage: failure.message,
      )),
      (provider) {
        final sortedReviews =
            List<ProviderDetailReviewEntity>.from(provider.reviews)
              ..sort((a, b) {
                final dateA = a.createdAt?.toLocalDateTime();
                final dateB = b.createdAt?.toLocalDateTime();
                if (dateA != null && dateB != null) {
                  return dateB.compareTo(dateA);
                }
                return (b.id ?? 0).compareTo(a.id ?? 0);
              });

        emit(state.copyWith(
          status: AppStatus.success,
          provider: provider.copyWith(reviews: sortedReviews),
        ));
      },
    );
  }
}
