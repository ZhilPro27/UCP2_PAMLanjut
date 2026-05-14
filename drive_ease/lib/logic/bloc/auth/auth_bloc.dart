import 'package:drive_ease/data/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'dart:developer' as developer;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      final token = await repository.getToken();
      final username = await repository.getUsername();
      if (token != null && username != null) {
        emit(Authenticated(token, username));
      } else {
        emit(Unauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      developer.log('Attempting login for: ${event.email}', name: 'AuthBloc');

      try {
        await repository.login(event.email, event.password);
        final token = await repository.getToken();
        final username = await repository.getUsername();

        if (token != null && username != null) {
          emit(Authenticated(token, username));
          developer.log('âœ… Status: Authenticated ', name: 'AuthBloc');
        } else {
          throw 'Token atau username tidak ditemukan setelah login';
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        developer.log('âŒ Status: AuthError - $e', name: 'AuthBloc');
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try{
        await repository.register(event.username, event.email, event.password);
        emit(Unauthenticated());
        developer.log('âœ… Status: Register Success', name: 'AuthBloc');
      } catch (e) {
        emit(AuthError(e.toString()));
        developer.log('âŒ Status: Register Error - $e', name: 'AuthBloc');
      }
    });

    on<LogoutRequested>((event, emit) async {
      await repository.deleteToken();
      emit(Unauthenticated());
      developer.log('ðŸšª Status: Logged Out', name: 'AuthBloc');
    });
  }
}