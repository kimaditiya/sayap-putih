
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sayap_putih/models/genre.dart';
import 'package:sayap_putih/models/pengarang.dart';
import 'package:sayap_putih/pengarang/presentation/edit/edit_form.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EditPengarang extends StatefulWidget {

  final PagingController<int, Pengarang> paging;

  final Pengarang ? pengarang;
 
  EditPengarang({Key? key,required this.paging,required this.pengarang}) : super(key: key);
  
  @override
  _EditPengarangState createState() => _EditPengarangState();
}

class _EditPengarangState extends State<EditPengarang> {

  List<Genre> _genrelist = [];

   Future<String> tokenLogged() async {
      // Read value 
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token") !;

    return token;

  }


  Future<List<Genre>> fetchGenre(http.Client client) async {
  var token = await tokenLogged();

   final response = await http.get(Uri.parse('https://soal.holywings.com/genre'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).timeout(Duration(seconds: 20));

     final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
     _genrelist = parsed.map<Genre>((json) => Genre.fromJson(json)).toList();

  // Use the compute function to run parsePhotos in a separate isolate.
  return _genrelist;
}

  

  @override
  Widget build(BuildContext context) {

  return new Scaffold(
      body: new FutureBuilder<List<Genre>>(
         future: fetchGenre(http.Client()), // a Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<List<Genre>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none: return new Text('Press button to start');
            case ConnectionState.waiting: return new Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return new AlertDialog(
                      content: Text('Sorry! Try again'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('RETRY'),
                          onPressed: () {
                            setState(() {});
                          },
                      )]);
              else
                return EditForm(paging: widget.paging, listgenre: snapshot.data, pengarang: widget.pengarang);
          }
        },
      )
    );
  }
}
