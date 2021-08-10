import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sayap_putih/genre/api_genre.dart';
import 'package:sayap_putih/genre/presentation/common/genre_search_input.dart';
import 'package:sayap_putih/genre/presentation/create/form_genre.dart';
import 'package:sayap_putih/genre/presentation/pull_to_refresh/genre_list_view.dart';
import 'package:sayap_putih/models/genre.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GenreList extends StatefulWidget {

  static const routeName = '/genre-list';

  @override
  _GenreListState createState() => _GenreListState();
}

class _GenreListState extends State<GenreList> {

  static const _pageSize = 20;
  final PagingController<int, Genre> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }


   Future<String?> usertoken() async {
      // Read value 
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    

    return token;

  }


  Future<void> _fetchPage(int pageKey) async {
    try {
      var token = await usertoken();
      final newItems = await ApiGenre.getGenreList(token);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch(error) {
      _pagingController.error = error;
    }
  }

    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Genre'),
      ),
      resizeToAvoidBottomInset: false,
      body: new Column(
      children: <Widget>[
        new Container(
          color: Colors.deepPurple,
          child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[   
                GenreSearchInput()
              ]
            ),
          ),
        ),
    new Expanded(
        child: GenreListView(paging: _pagingController)
      )
    ],
  ),
  floatingActionButton:  FloatingActionButton(
      onPressed: () async {
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context)=> FormGenre(paging: _pagingController)
              )
          );
      },
      child: Icon(Icons.add,color: Colors.white),
      backgroundColor: Colors.deepPurple,
    ),
  );
  }
  
}