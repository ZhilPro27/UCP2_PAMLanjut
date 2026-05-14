import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drive_ease/data/models/Katalog_model.dart';
import 'package:drive_ease/data/providers/Storage_provider.dart';

class KatalogRepository {
  final String baseUrl = "http://10.0.2.2:3000/api";
  final StorageProvider storageProvider = StorageProvider();

  Future<List<KatalogModel>> getAllKatalog() async {
    final token = await storageProvider.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/katalog'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }
    );

    if(response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => KatalogModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data katalog');
    }
  }

  Future<void> createKatalog(Map<String, dynamic> katalogData) async {
    final token = await storageProvider.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/katalog'),
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: jsonEncode(katalogData),
    );

    if(response.statusCode != 201 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? Exception('Gagal membuat katalog');
    }
  }

  Future<void> updateKatalog(int id, Map<String, dynamic> katalogData) async {
    final token = await storageProvider.getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/katalog/$id'),
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(katalogData),
    );

    if(response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? Exception('Gagal memperbarui katalog');
    }
  }

  Future<void> deleteKatalog(int id) async {
    final token = await storageProvider.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/katalog/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }
    );

    if(response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? Exception('Gagal menghapus katalog');
    }
  }

  Future<KatalogModel> getKatalogById(int id) async {
    final token = await storageProvider.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/katalog/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }
    );

    if(response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return KatalogModel.fromJson(body['data']);
    } else {
      final data = jsonDecode(response.body);
      throw data['message'] ?? Exception('Gagal mengambil data katalog');
    }
  }

  Future<List<KatalogModel>> searchKatalog(String query) async {
    final token = await storageProvider.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/katalog/search/?keyword=$query'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }
    );

    if(response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => KatalogModel.fromJson(item)).toList();
    } else {
      final data = jsonDecode(response.body);
      throw data['message'] ?? Exception('Gagal mencari katalog');
    }
  }
}