import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drive_ease/data/models/Kategori_model.dart';
import 'package:drive_ease/data/providers/Storage_provider.dart';

class KategoriRepository {
  final String baseUrl = "http://10.0.2.2:3000/api";
  final StorageProvider storageProvider = StorageProvider();

  Future<List<KategoriModel>> getAllKategori() async {
    final token = await storageProvider.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/kategori'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }
    );

    if(response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => KategoriModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data kategori');
    }
  }

  Future<void> createKategori(Map<String, dynamic> kategoriData) async {
    final token = await storageProvider.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/katergori'),
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: jsonEncode(kategoriData),
    );

    if(response.statusCode != 201 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? Exception('Gagal membuat kategori');
    }
  }

  Future<void> updateKategori(int id, Map<String, dynamic> kategoriData) async {
    final token = await storageProvider.getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/kategori/$id'),
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(kategoriData),
    );

    if(response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? Exception('Gagal memperbarui kategori');
    }
  }

  Future<void> deleteKategori(int id) async {
    final token = await storageProvider.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/kategori/$id'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      final data = jsonDecode(response.body);
      throw data['message'] ?? Exception('Gagal menghapus kategori');
    }
  }
}