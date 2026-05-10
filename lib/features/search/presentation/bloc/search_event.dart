
import '../../../../core/imports/imports.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchSubmitted extends SearchEvent {
  const SearchSubmitted();
}

class SearchLoadMore extends SearchEvent {
  const SearchLoadMore();
}

class SearchCleared extends SearchEvent {
  const SearchCleared();
}
