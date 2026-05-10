import 'package:equatable/equatable.dart';

class GovernorateEntity extends Equatable {
  final String id;
  final String name;

  const GovernorateEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
