import 'package:equatable/equatable.dart';

class PaginatedResponse<T> extends Equatable {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int total;

  const PaginatedResponse({
    required this.data,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
  });

  bool get hasMore => currentPage < lastPage;

  factory PaginatedResponse.empty() => const PaginatedResponse(data: []);

  PaginatedResponse<R> map<R>(R Function(T) mapper) {
    return PaginatedResponse<R>(
      data: data.map(mapper).toList(),
      currentPage: currentPage,
      lastPage: lastPage,
      total: total,
    );
  }

  PaginatedResponse<T> copyWith({
    List<T>? data,
    int? currentPage,
    int? lastPage,
    int? total,
  }) {
    return PaginatedResponse<T>(
      data: data ?? this.data,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [data, currentPage, lastPage, total];
}
