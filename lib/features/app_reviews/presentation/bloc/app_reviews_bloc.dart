import 'package:wassaly/core/imports/imports.dart';

import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../domain/entities/app_review_entity.dart';
import '../../domain/usecases/add_app_review_usecase.dart';
import '../../domain/usecases/get_app_reviews_usecase.dart';
import '../../domain/usecases/update_app_review_usecase.dart';
import 'app_reviews_event.dart';
import 'app_reviews_state.dart';

class AppReviewsBloc extends Bloc<AppReviewsEvent, AppReviewsState> {
  final GetAppReviewsUseCase _getAppReviewsUseCase;
  final AddAppReviewUseCase _addAppReviewUseCase;
  final UpdateAppReviewUseCase _updateAppReviewUseCase;
  final AuthLocalDataSource _authLocalDataSource;

  AppReviewsBloc(
    this._getAppReviewsUseCase,
    this._addAppReviewUseCase,
    this._updateAppReviewUseCase,
    this._authLocalDataSource,
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

    final user = await _authLocalDataSource.getCachedUser();
    final result = await _getAppReviewsUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: AppStatus.failure,
        errorMessage: failure.message,
      )),
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
        emit(state.copyWith(
          status: AppStatus.success,
          reviews: sortedReviews,
          clearError: true,
          currentUserId:
              user?.id != null ? int.tryParse(user!.id.toString()) : null,
        ));
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
      (failure) => emit(state.copyWith(
        actionStatus: AppStatus.failure,
        actionErrorMessage: failure.message,
      )),
      (review) {
        emit(state.copyWith(
          actionStatus: AppStatus.success,
        ));
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
      (failure) => emit(state.copyWith(
        actionStatus: AppStatus.failure,
        actionErrorMessage: failure.message,
      )),
      (updatedReview) {
        final updatedReviews = state.reviews.map((r) {
          return r.id == updatedReview.id ? updatedReview : r;
        }).toList();
        updatedReviews.sort((a, b) {
          try {
            final dateA = DateTime.parse(a.createdAt);
            final dateB = DateTime.parse(b.createdAt);
            return dateB.compareTo(dateA);
          } catch (_) {
            return b.id.compareTo(a.id);
          }
        });
        emit(state.copyWith(
          actionStatus: AppStatus.success,
          reviews: updatedReviews,
        ));
      },
    );
  }
}
