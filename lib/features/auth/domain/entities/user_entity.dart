import 'package:wassaly/core/imports/packages_imports.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? avatarUrl;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, email, name, phone, avatarUrl];
}
