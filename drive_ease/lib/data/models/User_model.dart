import 'package:equatable/equatable.dart';

class UserModel extends Equatable{
  final String user_id;
  final String username;

  const UserModel({
    required this.user_id,
    required this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user_id: json['user_id'] ?? '',
      username: json['username'] ?? '',
    );
  }

  @override
  List<Object?> get props => [user_id, username];
}