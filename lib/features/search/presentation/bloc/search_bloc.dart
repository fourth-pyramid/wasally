import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/search/domain/usecases/search_products_usecase.dart';
import 'package:wassaly/features/search/presentation/bloc/search_event.dart';
import 'package:wassaly/features/search/presentation/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchProductsUseCase _searchProductsUseCase;
  Timer? _debounceTimer;

  SearchBloc({
    required SearchProductsUseCase searchProductsUseCase,
  })  : _searchProductsUseCase = searchProductsUseCase,
        super(const SearchState()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchSubmitted>(_onSearchSubmitted);
    on<SearchLoadMore>(_onLoadMore);
    on<SearchCleared>(_onSearchCleared);
  }

  void _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) {
    _debounceTimer?.cancel();

    if (event.query.trim().isEmpty) {
      emit(
        state.copyWith(
          query: event.query,
          status: SearchStatus.initial,
          products: const PaginatedResponse(data: []),
          hasSearched: false,
          errorMessage: '',
        ),
      );
      return;
    }

    emit(state.copyWith(query: event.query));

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      add(const SearchSubmitted());
    });
  }

  Future<void> _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    _debounceTimer?.cancel();

    if (state.query.trim().isEmpty) {
      emit(
        state.copyWith(
          status: SearchStatus.initial,
          products: const PaginatedResponse(data: []),
          hasSearched: false,
          errorMessage: '',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: SearchStatus.loading,
        errorMessage: '',
        hasSearched: true,
      ),
    );

    final result = await _searchProductsUseCase(
      query: state.query.trim(),
    );

    result.fold(
      (failure) {
        // ponytail: Treat "not found" or empty-related failures as empty state
        final isNoResults =
            failure is NotFoundFailure || _isNoResults(failure.message);

        if (isNoResults) {
          emit(
            state.copyWith(
              status: SearchStatus.success,
              products: const PaginatedResponse(data: []),
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: SearchStatus.failure,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (paginatedResponse) => emit(
        state.copyWith(
          status: SearchStatus.success,
          products: paginatedResponse,
        ),
      ),
    );
  }

  Future<void> _onLoadMore(
    SearchLoadMore event,
    Emitter<SearchState> emit,
  ) async {
    if (state.status == SearchStatus.loadingMore || !state.products.hasMore) {
      return;
    }

    emit(state.copyWith(status: SearchStatus.loadingMore));

    final nextPage = state.products.currentPage + 1;

    final result = await _searchProductsUseCase(
      query: state.query.trim(),
      page: nextPage,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(status: SearchStatus.success));
      },
      (paginatedResponse) {
        emit(
          state.copyWith(
            status: SearchStatus.success,
            products: paginatedResponse.copyWith(
              data: [...state.products.data, ...paginatedResponse.data],
            ),
          ),
        );
      },
    );
  }

  void _onSearchCleared(SearchCleared event, Emitter<SearchState> emit) {
    _debounceTimer?.cancel();
    emit(const SearchState());
  }

  bool _isNoResults(String message) {
    final lower = message.toLowerCase();
    return lower.contains('not found') ||
        lower.contains('no products') ||
        lower.contains('no results') ||
        lower.contains('empty') ||
        lower.contains('لا توجد') ||
        lower.contains('لم يتم') ||
        lower.contains('لايوجد') ||
        lower.contains('غير موجود');
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
