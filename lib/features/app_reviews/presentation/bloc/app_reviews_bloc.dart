import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/app_reviews/domain/entities/app_review_entity.dart';
import 'package:wassaly/features/app_reviews/domain/usecases/add_app_review_usecase.dart';
import 'package:wassaly/features/app_reviews/domain/usecases/get_app_reviews_usecase.dart';
import 'package:wassaly/features/app_reviews/domain/usecases/update_app_review_usecase.dart';
import 'package:wassaly/features/app_reviews/presentation/bloc/app_reviews_event.dart';
import 'package:wassaly/features/app_reviews/presentation/bloc/app_reviews_state.dart';
import 'package:wassaly/features/auth/domain/usecases/get_cached_user_usecase.dart';

class AppReviewsBloc extends Bloc<AppReviewsEvent, AppReviewsState> {
  final GetAppReviewsUseCase _getAppReviewsUseCase;
  final AddAppReviewUseCase _addAppReviewUseCase;
  final UpdateAppReviewUseCase _updateAppReviewUseCase;
  final GetCachedUserUseCase _getCachedUserUseCase;

  AppReviewsBloc(
    this._getAppReviewsUseCase,
    this._addAppReviewUseCase,
    this._updateAppReviewUseCase,
    this._getCachedUserUseCase,
  ) : super(const AppReviewsState()) {
    on<GetAppReviewsEvent>(_onGetAppReviews);
    on<AddAppReviewEvent>(_onAddAppReview);
    on<UpdateAppReviewEvent>(_onUpdateAppReview);
  }

  Future<void> _onGetAppReviews(
    GetAppReviewsEvent event,
    Emitter<AppReviewsState> emit,
  ) async {
    if (state.reviews.isEmpty) {
      emit(state.copyWith(status: AppStatus.loading));
    }

    final userResult = await _getCachedUserUseCase();
    final user = userResult.fold((_) => null, (u) => u);
    final result = await _getAppReviewsUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AppStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (reviews) {
        final sortedReviews = List<AppReviewEntity>.from(reviews)
          ..sort((a, b) {
            final dateA = a.createdAt.toLocalDateTime();
            final dateB = b.createdAt.toLocalDateTime();
            if (dateA != null && dateB != null) {
              return dateB.compareTo(dateA);
            }
            return b.id.compareTo(a.id);
          });
        emit(
          state.copyWith(
            status: AppStatus.success,
            reviews: sortedReviews,
            clearError: true,
            currentUserId: user?.id != null ? int.tryParse(user!.id) : null,
          ),
        );
      },
    );
  }

  Future<void> _onAddAppReview(
    AddAppReviewEvent event,
    Emitter<AppReviewsState> emit,
  ) async {
    emit(state.copyWith(actionStatus: AppStatus.loading));

    final result = await _addAppReviewUseCase(
      rating: event.rating,
      comment: event.comment,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: AppStatus.failure,
          actionErrorMessage: failure.message,
        ),
      ),
      (review) {
        emit(
          state.copyWith(
            actionStatus: AppStatus.success,
          ),
        );
        add(const GetAppReviewsEvent());
      },
    );
  }

  Future<void> _onUpdateAppReview(
    UpdateAppReviewEvent event,
    Emitter<AppReviewsState> emit,
  ) async {
    emit(state.copyWith(actionStatus: AppStatus.loading));

    final result = await _updateAppReviewUseCase(
      reviewId: event.reviewId,
      rating: event.rating,
      comment: event.comment,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: AppStatus.failure,
          actionErrorMessage: failure.message,
        ),
      ),
      (updatedReview) {
        final updatedReviews = state.reviews
            .map((r) => r.id == updatedReview.id ? updatedReview : r)
            .toList()
          ..sort((a, b) {
            try {
              final dateA = DateTime.parse(a.createdAt);
              final dateB = DateTime.parse(b.createdAt);
              return dateB.compareTo(dateA);
            } on Exception catch (_) {
              return b.id.compareTo(a.id);
            }
          });
        emit(
          state.copyWith(
            actionStatus: AppStatus.success,
            reviews: updatedReviews,
          ),
        );
      },
    );
  }
}
