import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sayap_putih/models/pengarang.dart';

class ApiPengarang {
  static Future<List<Pengarang>> getPengarangList(token,{
    String? searchTerm,
  }) async =>
      http
          .get(
            _ApiUrlBuilder.getPengarangList(token,searchTerm: searchTerm),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }
          )
          .mapFromResponse<List<Pengarang>, List<dynamic>>(
            (jsonArray) => _parseItemListFromJsonArray(
              jsonArray,
              (jsonObject) => Pengarang.fromJson(jsonObject),
            ),
          );

  static List<T> _parseItemListFromJsonArray<T>(
    List<dynamic> jsonArray,
    T Function(dynamic object) mapper,
  ) =>
      jsonArray.map(mapper).toList();
}

class GenericHttpException implements Exception {}

class NoConnectionException implements Exception {}
class _ApiUrlBuilder {
  static const _baseUrl = 'https://soal.holywings.com';
  static const _genreResource = '/pengarang/';

  static Uri getPengarangList(
    token,{
     searchTerm,
  }) =>
     Uri.parse('$_baseUrl$_genreResource');
}

extension on Future<http.Response> {
  Future<R> mapFromResponse<R, T>(R Function(T) jsonParser) async {
    try {
      final response = await this.timeout(Duration(seconds: 20));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return jsonParser(data);
      } else {
        throw GenericHttpException();
      }
    } on SocketException {
      throw NoConnectionException();
    }
  }
}