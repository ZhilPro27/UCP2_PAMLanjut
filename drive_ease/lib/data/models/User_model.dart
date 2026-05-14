import 'package:equatable/equatable.dart';

class UserModel extends Equatable{
  final int user_id;
  final String email;
  final String username;

  const UserModel({
    required this.user_id,
    required this.email,
    required this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user_id: json['user_id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
    );
  }

  @override
  List<Object?> get props => [user_id, email, username];
}