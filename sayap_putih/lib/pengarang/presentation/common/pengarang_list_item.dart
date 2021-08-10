import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sayap_putih/models/pengarang.dart';
import 'package:sayap_putih/pengarang/presentation/edit/edit_screen.dart';



/// List item representing a single Character with its photo and name.
class pengarangListItem extends StatelessWidget {
  const pengarangListItem({
    @required this.pengarang,
    required this.paging,
    @required this.token,
    Key? key,
  })  : assert(pengarang != null),
        assert(token != null),
        super(key: key);

  final Pengarang? pengarang;
  final PagingController<int, Pengarang> paging;
  final String? token;

  @override
  Widget build(BuildContext context) => ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage:AssetImage('assets/avatar.jpg'),
          ),
          title:new Text('Nama: '+ pengarang!.nama,
              style: TextStyle(color: Colors.black, fontSize: 16.0)),
              subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tanggal Lahir : ${pengarang!.tanggalLahir}",
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                    Text("Genre: ${pengarang!.genre?.name}",
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
                            builder: (BuildContext context)=> EditPengarang(paging: paging,pengarang: pengarang))
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