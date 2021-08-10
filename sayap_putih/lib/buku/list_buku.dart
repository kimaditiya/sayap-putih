import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sayap_putih/buku/api_buku.dart';
import 'package:sayap_putih/buku/presentation/common/buku_search_input.dart';
import 'package:sayap_putih/buku/presentation/create/create_screen_buku.dart';
import 'package:sayap_putih/buku/presentation/pull_to_refresh/buku_list_view.dart';
import 'package:sayap_putih/models/buku.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BukuList extends StatefulWidget {

  static const routeName = '/buku-list';

  @override
  _BukuListState createState() => _BukuListState();
}

class _BukuListState extends State<BukuList> {

  static const _pageSize = 20;
  final PagingController<int, Buku> _pagingController =
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
      final newItems = await ApiBuku.getBukuList(token);
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
        title: const Text('List Buku'),
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
                BukuSearchInput()
              ]
            ),
          ),
        ),
    new Expanded(
        child: BukuListView(paging: _pagingController)
      )
    ],
  ),
  floatingActionButton:  FloatingActionButton(
      onPressed: () async {
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context)=> AddBuku(paging: _pagingController)
              )
          );
      },
      child: Icon(Icons.add,color: Colors.white),
      backgroundColor: Colors.deepPurple,
    ),
  );
  }
  
}