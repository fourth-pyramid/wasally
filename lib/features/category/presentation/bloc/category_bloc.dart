import '../../../../core/imports/imports.dart';
import '../../domain/usecases/get_category_detail_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoryDetailUseCase _getCategoryDetailUseCase;

  CategoryBloc({
    required GetCategoryDetailUseCase getCategoryDetailUseCase,
  })  : _getCategoryDetailUseCase = getCategoryDetailUseCase,
        super(const CategoryState()) {
    on<FetchCategoryDetailEvent>(_onFetchCategoryDetail);
    on<LoadMoreSubCategoriesEvent>(_onLoadMoreSubCategories);
  }

  Future<void> _onFetchCategoryDetail(
    FetchCategoryDetailEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));

    final result = await _getCategoryDetailUseCase(event.categoryId, page: 1);

    result.fold(
      (failure) => emit(state.copyWith(
        status: CategoryStatus.failure,
        errorMessage: failure.message,
      )),
      (categoryDetail) => emit(state.copyWith(
        status: CategoryStatus.success,
        categoryDetail: categoryDetail,
        subCategories: categoryDetail.subCategories,
      )),
    );
  }

  Future<void> _onLoadMoreSubCategories(
    LoadMoreSubCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMoreSubCategories) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;

    final result =
        await _getCategoryDetailUseCase(event.categoryId, page: nextPage);

    result.fold(
      (failure) {
        emit(state.copyWith(isLoadingMore: false));
      },
      (categoryDetail) {
        emit(state.copyWith(
          isLoadingMore: false,
          subCategories: categoryDetail.subCategories.copyWith(
            data: [
              ...state.subCategories.data,
              ...categoryDetail.subCategories.data,
            ],
          ),
        ));
      },
    );
  }
}
