import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sayap_putih/member/common/member_list_item.dart';
import 'package:sayap_putih/models/member.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MemberListView extends StatefulWidget {

  final PagingController<int, Member> paging;

  MemberListView({Key? key,required this.paging}) : super(key: key);

  @override
  _MemberListViewState createState() => _MemberListViewState();
}

class _MemberListViewState extends State<MemberListView> {

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
      child:PagedListView<int, Member>.separated(
      pagingController: widget.paging,
      builderDelegate: PagedChildBuilderDelegate<Member>(
        itemBuilder: (context, item, index) => MemberListItem(
          member: item,
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