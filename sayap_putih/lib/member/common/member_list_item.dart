import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sayap_putih/member/edit/edit_screen.dart';
import 'package:sayap_putih/models/member.dart';



/// List item representing a single Character with its photo and name.
class MemberListItem extends StatelessWidget {
  const MemberListItem({
    required this.member,
    required this.paging,
    @required this.token,
    Key? key,
  })  :
        assert(token != null),
        super(key: key);

  final Member member;
  final PagingController<int, Member> paging;
  final String? token;

  @override
  Widget build(BuildContext context) => ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage:AssetImage('assets/avatar.jpg'),
          ),
          title:new Text('Nama : '+ member.nama,
              style: TextStyle(color: Colors.black, fontSize: 16.0)),
              subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tanggal Lahir : ${member.tanggalLahir}",
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                    Text("Genre favorit : ${member.genre.first.name}",
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                    Text("Pengarang favorit : ${member.pengarang.first.name}",
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    )
              ]),
              trailing: Wrap(
                spacing: 8, // space between two icons
                children: <Widget>[
                   new IconButton(
                    icon: new Icon(Icons.edit),
                    onPressed: (){
                       Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context)=> EditMember(paging: paging, member: member))
                        );
                    },
                  ),
                  new IconButton(
                    icon: new Icon(Icons.delete),
                    onPressed: (){
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.WARNING,
                        headerAnimationLoop: false,
                        animType: AnimType.TOPSLIDE,
                        showCloseIcon: true,
                        closeIcon: Icon(Icons.close_fullscreen_outlined),
                        title: 'Warning',
                        desc:
                            'Are You Okay Delete ?',
                        btnCancelOnPress: () {},
                        onDissmissCallback: (type) {
                          debugPrint('Dialog Dissmiss from callback $type');
                        },
                        btnOkOnPress: () {

                        })
                      ..show();
                    },
                  ) // icon-2
                ],
              ), 
        );
}