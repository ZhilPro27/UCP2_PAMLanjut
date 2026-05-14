import 'package:equatable/equatable.dart';

class KategoriModel extends Equatable{
  final String kategori_id;
  final String nama;
  final String updated_at;

  const KategoriModel({
    required this.kategori_id,
    required this.nama,
    required this.updated_at,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      kategori_id: json['kategori_id'] ?? '',
      nama: json['nama'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  @override
  List<Object?> get props => [kategori_id, nama, updated_at];
}