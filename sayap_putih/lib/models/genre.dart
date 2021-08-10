class Genre {
  final int id;
  final String name;

  const Genre({
    required this.id,
    required this.name,
  });

   static List<Genre> fromJsonList(List list) {
    return list.map((item) => Genre.fromJson(item)).toList();
  }

    ///this method will prevent the override of toString
  bool genreFilterByName(String filter) {
    return this.name.toLowerCase().contains(filter) || this.name.contains(filter) ;
  }

  @override
  String toString() => id.toString();


  ///custom comparing function to check if two users are equal
  bool isEqual(Genre? model) {
    return this.id == model?.id;
  }

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as int,
      name: json['name'] as String
    );
  }
}