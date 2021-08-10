
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sayap_putih/member/edit/edit_form.dart';
import 'package:sayap_putih/models/genre.dart';
import 'package:sayap_putih/models/member.dart';
import 'package:sayap_putih/models/pengarang.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EditMember extends StatefulWidget {

  final PagingController<int, Member> paging;

  final Member member;
 
  EditMember({Key? key,required this.paging,required this.member}) : super(key: key);
  
  @override
  _EditMemberState createState() => _EditMemberState();
}

class _EditMemberState extends State<EditMember> {

  List<Genre>? _genrelist = [];

  List<Pengarang> _pengaranglist = [];

   Future<String> tokenLogged() async {
      // Read value 
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token") !;

    return token;

  }


  Future<List<Genre>?> fetchGenre(http.Client client) async {
  var token = await tokenLogged();

   final response = await http.get(Uri.parse('https://soal.holywings.com/genre'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).timeout(Duration(seconds: 20));

     final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
     _genrelist = parsed.map<Genre>((json) => Genre.fromJson(json)).toList();

     print(parsed);

  // Use the compute function to run parsePhotos in a separate isolate.
  return _genrelist;
}

  Future<List<Pengarang>?> fetchPengarang(http.Client client) async {
  var token = await tokenLogged();

   final response = await http.get(Uri.parse('https://soal.holywings.com/pengarang/'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).timeout(Duration(seconds: 20));

     final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
     _pengaranglist = parsed.map<Pengarang>((json) => Pengarang.fromJson(json)).toList();

      print(response.body);

  // Use the compute function to run parsePhotos in a separate isolate.
  return _pengaranglist;
}

  

  @override
  Widget build(BuildContext context) {

  return new Scaffold(
      body: new FutureBuilder<List<dynamic>>(
         future: Future.wait([fetchGenre(http.Client()),fetchPengarang(http.Client())]), // a Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none: return new Text('Press button to start');
            case ConnectionState.waiting: return new Center(child: CircularProgressIndicator());
            default:

            print(snapshot.data);
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
                return EditFormMember(paging: widget.paging, listgenre: snapshot.data?[0], listpengarang: snapshot.data?[1],member: widget.member);
          }
        },
      )
    );
  }
}
