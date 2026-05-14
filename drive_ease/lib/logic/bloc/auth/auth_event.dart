import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {}
class LoginRequested extends AuthEvent{
  final String email, password;
  LoginRequested({required this.email, required this.password});
}
class RegisterRequested extends AuthEvent{
  final String username, email, password;
  RegisterRequested({required this.username, required this.email, required this.password});
}
class LogoutRequested extends AuthEvent {}