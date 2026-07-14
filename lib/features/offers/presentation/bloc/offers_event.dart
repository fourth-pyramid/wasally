import 'package:wassaly/core/imports/packages_imports.dart';

abstract class OffersEvent extends Equatable {
  const OffersEvent();

  @override
  List<Object?> get props => [];
}

class GetOffersEvent extends OffersEvent {}

class LoadMoreOffersEvent extends OffersEvent {}
