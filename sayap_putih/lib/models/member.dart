import 'package:sayap_putih/models/genre.dart';
import 'package:sayap_putih/models/pengarangbuku.dart';

class Member {
  final int id;
  final String alamat;
  final String tanggalLahir;
  final String nama;
  final List<Genre> genre;
  final List<PengarangBuku> pengarang;

  const Member({
    required this.id,
    required this.alamat,
    required this.tanggalLahir,
    required this.nama,
    required this.genre,
    required this.pengarang
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as int,
      nama: json['nama'] as String,
      alamat: json['alamat'] as String,
      tanggalLahir: json['tanggalLahir'] as String,
      genre: List<Genre>.from(json["genreFavorit"].map((x) => Genre.fromJson(x))),
      pengarang: List<PengarangBuku>.from(json["pengarangFavorit"].map((x) => PengarangBuku.fromJson(x)))
    );
  }
}