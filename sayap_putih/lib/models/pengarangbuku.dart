class PengarangBuku {
  final String name;
  final int id;

  const PengarangBuku({
    required this.name,
    required this.id,
  });

  static List<PengarangBuku> fromJsonList(List list) {
    return list.map((item) => PengarangBuku.fromJson(item)).toList();
  }

    ///this method will prevent the override of toString
  bool pengarangFilterByName(String filter) {
    return this.name.toLowerCase().contains(filter) || this.name.contains(filter) ;
  }

  @override
  String toString() => id.toString();


  ///custom comparing function to check if two users are equal
  bool isEqual(PengarangBuku? model) {
    return this.id == model?.id;
  }

  factory PengarangBuku.fromJson(Map<String, dynamic> json) {
    return PengarangBuku(
      name: json['name'] as String,
      id: json['id'] as int,
    );
  }
}