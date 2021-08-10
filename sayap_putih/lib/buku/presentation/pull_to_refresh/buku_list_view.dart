import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sayap_putih/buku/presentation/common/buku_list_item.dart';
import 'package:sayap_putih/models/buku.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';


class BukuListView extends StatefulWidget {

  final PagingController<int, Buku> paging;

  BukuListView({Key? key,required this.paging}) : super(key: key);

  @override
  _BukuListViewState createState() => _BukuListViewState();
}

class _BukuListViewState extends State<BukuListView> {

  

    @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () => Future.sync(() => widget.paging.refresh()),
    child: Scrollbar(
      child:PagedListView<int, Buku>.separated(
      pagingController: widget.paging,
      builderDelegate: PagedChildBuilderDelegate<Buku>(
        itemBuilder: (context, item, index) => BukuListItem(
          buku: item,
          paging: widget.paging
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