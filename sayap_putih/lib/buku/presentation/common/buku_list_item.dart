import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sayap_putih/buku/presentation/edit/edit_screen_buku.dart';
import 'package:sayap_putih/models/buku.dart';

/// List item representing a single asset with its Tahun Kendaraan and Asset Name.
class BukuListItem extends StatelessWidget {
  const BukuListItem({
    required this.buku,
    required this.paging,
    Key? key,
  })  : 
        super(key: key);

  final Buku buku;
  final PagingController<int, Buku> paging;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
       
    },
    child:Card(
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                         
                          new Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.topLeft,
                            child:
                             FadeInImage.assetNetwork(
                              width: 80.0,
                              height: 100,
                              imageCacheHeight: 100,
                              imageCacheWidth: 80,
                              placeholder: 'assets/loading-load.gif',
                              image: "https://cdn.gramedia.com/uploads/items/9786020333175_rich-dad-poor-dad-_edisi-revisi_.jpg",
                            ) 
                            
                          ) ,
                              new Expanded(
                                child: new Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Genre : ${buku.genre.first.name}",
                                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                                      ),
                                      Text("harga : ${buku.harga}",
                                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                                      ),
                                      Text("Lokasi : ${buku.lokasi}",
                                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                                      ),
                                      Text("Pengarang : ${buku.pengarang.first.name}",
                                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                                      ),

                                      Text("Boleh Pinjam : ${buku.pinjam ? 'ya':'tidak'}",
                                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                                      ),

                                      Text("Tahun terbit: ${buku.tahun}",
                                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                                      ),
                                      
                                    
                                ]),
                              )
                              ),
                              new Column(
                              children: <Widget>[
                              new IconButton(
                              icon: new Icon(Icons.edit),
                              onPressed: () {
                                Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (BuildContext context)=> EditBuku(paging: paging, buku: buku)
                                    )
                                );
                              })]),
                            ],
                          crossAxisAlignment: CrossAxisAlignment.start
                        )
                      ),
    // child:ListTile(
    //      leading: new Image.network(
    //        'https://cdn.gramedia.com/uploads/items/9786020333175_rich-dad-poor-dad-_edisi-revisi_.jpg',
    //         fit: BoxFit.cover,
    //         // height: 580.0,
    //         width: 100.0,
    //       ),
    //     title: Text("Judul : ${buku.judul}"),
    //     subtitle: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text("Genre : ${buku.genre.first.name}",
    //             style: TextStyle(color: Colors.black, fontSize: 16.0),
    //           ),
    //           Text("harga : ${buku.harga}",
    //             style: TextStyle(color: Colors.black, fontSize: 16.0),
    //           ),
    //           Text("Lokasi : ${buku.lokasi}",
    //             style: TextStyle(color: Colors.black, fontSize: 16.0),
    //           ),
    //           Text("Pengarang : ${buku.pengarang.first.name}",
    //             style: TextStyle(color: Colors.black, fontSize: 16.0),
    //           ),

    //           Text("Tahun : ${buku.tahun}",
    //             style: TextStyle(color: Colors.black, fontSize: 16.0),
    //           ),
             
    //     ]),
    //     trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    //   )
    );
}