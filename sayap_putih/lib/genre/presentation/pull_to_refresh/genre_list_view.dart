import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sayap_putih/genre/presentation/common/genre_list_item.dart';
import 'package:sayap_putih/models/genre.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GenreListView extends StatefulWidget {

  final PagingController<int, Genre> paging;

  GenreListView({Key? key,required this.paging}) : super(key: key);

  @override
  _GenreListViewState createState() => _GenreListViewState();
}

class _GenreListViewState extends State<GenreListView> {

  String? _token;

  Future<void> usertoken() async {
      // Read value 
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _token =  preferences.getString("token");
    });

  }

    @override
  void initState() {
    usertoken();
    super.initState();
  }


  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () => Future.sync(() => widget.paging.refresh()),
    child: Scrollbar(
      child:PagedListView<int, Genre>.separated(
      pagingController: widget.paging,
      builderDelegate: PagedChildBuilderDelegate<Genre>(
        itemBuilder: (context, item, index) => GenreListItem(
          genre: item,
          paging: widget.paging,
          token: _token,
        ),
      ),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(left: 60,right: 10),
        child: Divider(thickness: 1.50,),
      ),
    )
    ),
  );

  @override
  void dispose() {
    widget.paging.dispose();
    super.dispose();
  }
}