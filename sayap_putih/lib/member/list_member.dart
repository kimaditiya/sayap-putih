import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sayap_putih/member/api_member.dart';
import 'package:sayap_putih/member/common/member_search_input.dart';
import 'package:sayap_putih/member/create/add_screen.dart';
import 'package:sayap_putih/member/pull_to_refresh/member_list_view.dart';
import 'package:sayap_putih/models/member.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MemberList extends StatefulWidget {

  static const routeName = '/pengarang-list';

  @override
  _MemberListState createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {

  static const _pageSize = 20;
  final PagingController<int, Member> _pagingController =
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
      final newItems = await ApiMember.getMemberList(token);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch(error) {
      print(error);
      _pagingController.error = error;
    }
  }

    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Member'),
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
                MemberSearchInput()
              ]
            ),
          ),
        ),
    new Expanded(
        child: MemberListView(paging: _pagingController)
      )
    ],
  ),
  floatingActionButton:  FloatingActionButton(
      onPressed: () async {
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context)=> AddMember(paging: _pagingController)
              )
          );
      },
      child: Icon(Icons.add,color: Colors.white),
      backgroundColor: Colors.deepPurple,
    ),
  );
  }
  
}