import 'package:sayap_putih/models/genre.dart';

class Pengarang {
  final String nama;
  final String tanggalLahir;
  final int id;
  final Genre? genre;

  const Pengarang({
    required this.nama,
    required this.tanggalLahir,
    required this.id,
     this.genre,
  });

static List<Pengarang> fromJsonList(List list) {
    return list.map((item) => Pengarang.fromJson(item)).toList();
  }

    ///this method will prevent the override of toString
  bool pengarangFilterByName(String filter) {
    return this.nama.toLowerCase().contains(filter) || this.nama.contains(filter) ;
  }

  @override
  String toString() => id.toString();


  ///custom comparing function to check if two users are equal
  bool isEqual(Pengarang? model) {
    return this.id == model?.id;
  }

  factory Pengarang.fromJson(Map<String, dynamic> json) {
    return Pengarang(
      nama: json['nama'] as String,
      tanggalLahir: json['tanggalLahir'] as String,
      id: json['id'] as int,
      genre: Genre.fromJson(json["genreSpecialization"])
    );
  }
}