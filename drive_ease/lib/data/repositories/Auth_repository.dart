import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/User_Model.dart';
import 'dart:developer' as developer;

class AuthRepository {
  final String baseUrl = "http://10.0.2.2:3000/api";
  final _storage = const FlutterSecureStorage();

  Future<void> persistToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> deleteToken() async {
    return await _storage.delete(key: 'jwt_token');
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      developer.log('Response Login: ${response.body}', name: 'API');

      if (response.statusCode == 200) {
        final token = data['token'];
        await persistToken(token);
        return UserModel.fromJson(data['user']);
      } else {
        String errorMessage = 'Gagal Login';
        if (data['message'] != null) {
          errorMessage = data['message'];
        } else if (data['errors'] != null && data['errors'] is List && data['errors'].isNotEmpty) {
          errorMessage = data['errors'][0]['msg'] ?? 'Gagal Login';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      developer.log('Error pada login: $e', name: 'API');
      rethrow;
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
        }),
      );

      developer.log('Response Register: ${response.body}', name: 'API');

      if (response.statusCode != 201 && response.statusCode != 200) {
        final data = jsonDecode(response.body);
        String errorMessage = 'Gagal Register';
        if (data['message'] != null) {
          errorMessage = data['message'];
        } else if (data['errors'] != null && data['errors'] is List && data['errors'].isNotEmpty) {
          errorMessage = data['errors'][0]['msg'] ?? 'Gagal Register';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      developer.log('Error pada register: $e', name: 'API');
      rethrow;
    }
  }
}