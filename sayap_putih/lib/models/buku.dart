import 'package:sayap_putih/models/genre.dart';
import 'package:sayap_putih/models/pengarangbuku.dart';

class Buku {
  final int id;
  final String judul;
  final String lokasi;
  final List<Genre> genre;
  final List<PengarangBuku> pengarang;
  // final String keyword;
  final bool pinjam;
  final String tahun;
  final int harga;

  const Buku({
    required this.id,
    required this.judul,
    required this.lokasi,
    required this.genre,
    required this.pengarang,
    // required this.keyword,
    required this.pinjam,
    required this.tahun,
    required this.harga
  });

  factory Buku.fromJson(Map<String, dynamic> json) { 
   
    return Buku(
      id: json['id'] as int,
      judul: json['judul'] as String,
      lokasi: json['lokasi'] as String,
     
      // genre: Genre.fromJson(json["genre"][0]),
      pengarang: List<PengarangBuku>.from(json["pengarang"].map((x) => PengarangBuku.fromJson(x))),

       genre: List<Genre>.from(json["genre"].map((x) => Genre.fromJson(x))),
      // pengarang: PengarangBuku.fromJson(json["pengarang"][0]),
      // keyword: json['keyword'][0],
      //  keyword:List.from(json['keyword']),
      // // pengarang: List<Pengarang>.from(json["pengarang"].map((x) => Pengarang.fromJson(x)))
      pinjam: json['pinjam'] as bool,
      tahun: json['tahunTerbit'] as String,
      harga: json['harga'] as int
    );
  }
}