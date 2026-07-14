import 'package:wassaly/core/imports/packages_imports.dart';

class PaginatedResponse<T> extends Equatable {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int total;
  final int totalUnread;

  const PaginatedResponse({
    required this.data,
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
    this.totalUnread = 0,
  });

  factory PaginatedResponse.fromJson({
    required Map<String, dynamic> json,
    required List<T> data,
  }) {
    // Some APIs wrap pagination in a 'pagination' or 'meta' object,
    // others put it inside 'data' (Laravel style), or at the root.
    var metadata = json;

    if (json['pagination'] is Map<String, dynamic>) {
      metadata = json['pagination'] as Map<String, dynamic>;
    } else if (json['meta'] is Map<String, dynamic>) {
      metadata = json['meta'] as Map<String, dynamic>;
    } else if (json['data'] is Map<String, dynamic> &&
        (json['data'] as Map).containsKey('current_page')) {
      metadata = json['data'] as Map<String, dynamic>;
    }

    return PaginatedResponse<T>(
      data: data,
      currentPage: (metadata['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (metadata['last_page'] as num?)?.toInt() ?? 1,
      total: (metadata['total'] as num?)?.toInt() ?? data.length,
      totalUnread: (json['unread_count'] as num?)?.toInt() ??
          (json['unreadCount'] as num?)?.toInt() ??
          (json['total_unread'] as num?)?.toInt() ??
          (json['totalUnread'] as num?)?.toInt() ??
          (json['data'] is Map<String, dynamic>
              ? ((json['data'] as Map<String, dynamic>)['unread_count'] as num?)?.toInt() ??
                  ((json['data'] as Map<String, dynamic>)['unreadCount'] as num?)
                      ?.toInt() ??
                  ((json['data'] as Map<String, dynamic>)['total_unread'] as num?)
                      ?.toInt() ??
                  ((json['data'] as Map<String, dynamic>)['totalUnread'] as num?)
                      ?.toInt()
              : null) ??
          (json['meta'] is Map<String, dynamic>
              ? ((json['meta'] as Map<String, dynamic>)['unread_count']
                          as num?)
                      ?.toInt() ??
                  ((json['meta'] as Map<String, dynamic>)['unreadCount']
                          as num?)
                      ?.toInt() ??
                  ((json['meta'] as Map<String, dynamic>)['total_unread']
                          as num?)
                      ?.toInt() ??
                  ((json['meta'] as Map<String, dynamic>)['totalUnread']
                          as num?)
                      ?.toInt()
              : null) ??
          0,
    );
  }

  factory PaginatedResponse.fromList(List<T> data) => PaginatedResponse<T>(
        data: data,
        total: data.length,
      );

  bool get hasMore => currentPage < lastPage;

  factory PaginatedResponse.empty() => PaginatedResponse<T>(data: const []);

  PaginatedResponse<R> map<R>(R Function(T) mapper) => PaginatedResponse<R>(
        data: data.map(mapper).toList(),
        currentPage: currentPage,
        lastPage: lastPage,
        total: total,
        totalUnread: totalUnread,
      );

  PaginatedResponse<T> copyWith({
    List<T>? data,
    int? currentPage,
    int? lastPage,
    int? total,
    int? totalUnread,
  }) =>
      PaginatedResponse<T>(
        data: data ?? this.data,
        currentPage: currentPage ?? this.currentPage,
        lastPage: lastPage ?? this.lastPage,
        total: total ?? this.total,
        totalUnread: totalUnread ?? this.totalUnread,
      );

  @override
  List<Object?> get props => [data, currentPage, lastPage, total, totalUnread];
}
