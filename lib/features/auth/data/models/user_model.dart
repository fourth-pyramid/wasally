import 'package:wassaly/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String? token;

  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.phone,
    super.avatarUrl,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'avatar_url': avatarUrl,
      'token': token,
    };
  }
}
