import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sayap_putih/genre/presentation/edit/edit_form.dart';
import 'package:sayap_putih/models/genre.dart';



/// List item representing a single Character with its photo and name.
class GenreListItem extends StatelessWidget {
  const GenreListItem({
    @required this.genre,
    required this.paging,
    @required this.token,
    Key? key,
  })  : assert(genre != null),
        assert(token != null),
        super(key: key);

  final Genre? genre;
  final PagingController<int, Genre> paging;
  final String? token;

  @override
  Widget build(BuildContext context) => ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage:AssetImage('assets/genre.jpg'),
          ),
          title: new Text(genre!.name,
              style: TextStyle(color: Colors.black, fontSize: 16.0)),
              trailing: Wrap(
                spacing: 8, // space between two icons
                children: <Widget>[
                   new IconButton(
                    icon: new Icon(Icons.edit),
                    onPressed: (){
                       Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context)=> EditGenre(paging: paging, genre: genre))
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