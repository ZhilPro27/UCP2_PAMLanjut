import 'package:equatable/equatable.dart';

class KatalogModel extends Equatable {
  final int katalog_id;
  final String nama;
  final String deskripsi;
  final int kategori_id;
  final double harga;
  final String kondisi;
  final String status;
  final String nomor_polisi;
  final String updated_at;

  const KatalogModel({
    required this.katalog_id,
    required this.nama,
    required this.deskripsi,
    required this.kategori_id,
    required this.harga,
    required this.kondisi,
    required this.status,
    required this.nomor_polisi,
    required this.updated_at,
  });

  factory KatalogModel.fromJson(Map<String, dynamic> json) {
    return KatalogModel(
      katalog_id: json['katalog_id'] ?? '',
      nama: json['nama'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      kategori_id: json['kategori_id'] ?? '',
      harga: (json['harga'] != null) ? double.tryParse(json['harga'].toString()) ?? 0.0 : 0.0,
      kondisi: json['kondisi'] ?? '',
      status: json['status'] ?? '',
      nomor_polisi: json['nomor_polisi'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  @override
  List<Object?> get props => [katalog_id, nama, deskripsi, kategori_id, harga, kondisi, status, nomor_polisi, updated_at];
}