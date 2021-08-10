import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sayap_putih/models/pengarang.dart';
import 'package:sayap_putih/pengarang/presentation/common/pengarang_list_item.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PengarangListView extends StatefulWidget {

  final PagingController<int, Pengarang> paging;

  PengarangListView({Key? key,required this.paging}) : super(key: key);

  @override
  _PengarangListViewState createState() => _PengarangListViewState();
}

class _PengarangListViewState extends State<PengarangListView> {

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
      child:PagedListView<int, Pengarang>.separated(
      pagingController: widget.paging,
      builderDelegate: PagedChildBuilderDelegate<Pengarang>(
        itemBuilder: (context, item, index) => pengarangListItem(
          pengarang: item,
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