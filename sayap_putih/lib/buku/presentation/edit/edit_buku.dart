import 'dart:async';
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sayap_putih/models/buku.dart';
import 'package:sayap_putih/models/genre.dart';
import 'package:sayap_putih/models/pengarang.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditFormBuku extends StatefulWidget {

  final PagingController<int, Buku> paging;

  final List<Genre> listgenre;

  final List<Pengarang> listpengarang;

  final Buku buku;

  EditFormBuku({Key? key, required this.paging,required this.listgenre,required this.listpengarang,required this.buku}) : super(key: key);


  @override
  _EditFormBukuState createState() => _EditFormBukuState();
}

class _EditFormBukuState extends State<EditFormBuku> {

  final TextEditingController controllerTahunterbit = new TextEditingController();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _keywordController = TextEditingController();

  final TextEditingController _hargaController = TextEditingController();
  

  Timer? _timer;
  final _formKey = GlobalKey<FormState>();
  Genre? _genre;
  Pengarang? _penggarang;
  bool ispinjam = true;


  final Map<String, dynamic> formData = {
      "genre": [
        0
      ],
      "harga": 0,
      "judul": "",
      "keyword": [
        ""
      ],
      "lokasi": "",
      "pengarang": [
        0
      ],
      "pinjam": true,
      "tahunTerbit": ""
    };

  Future<String?> usertoken() async {
      // Read value 
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
   

    return token;

  }


      @override
  void initState() {
    _hargaController.text = widget.buku.harga.toString();
    _judulController.text = widget.buku.judul.toString();
    _lokasiController.text = widget.buku.lokasi.toString();
    controllerTahunterbit.text =  widget.buku.tahun.toString();
    ispinjam = widget.buku.pinjam;
    _genre  = Genre(id: widget.buku.genre.first.id,name: widget.buku.genre.first.name);
     _penggarang  = Pengarang(id: widget.buku.pengarang.first.id,nama: widget.buku.pengarang.first.name,tanggalLahir: '1998');
    super.initState();
     EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }
  

  void finish(){
    widget.paging.refresh();
    var count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 1;
    });
  }


  @override
  Widget build(BuildContext context) {

       Widget _customDropDownLevel(
      BuildContext context, Genre? item, String itemDesignation) {
    return Container(
      child: (item?.id == null)
          ? ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(),
              title: Text("No item selected"),
            )
          : ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(),
              title: Text(item!.name),
            ),
    );
  }

  Widget _customPopupItemBuilderLevel(
      BuildContext context, Genre item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.name),
         leading: CircleAvatar(),
      ),
    );
  }

    Widget _customDropDownLevel2(
      BuildContext context, Pengarang? item, String itemDesignation) {
    return Container(
      child: (item?.id == null)
          ? ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(),
              title: Text("No item selected"),
            )
          : ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: CircleAvatar(),
              title: Text(item!.nama),
            ),
    );
  }

  Widget _customPopupItemBuilderLevel2(
      BuildContext context, Pengarang item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.nama),
         leading: CircleAvatar(),
      ),
    );
  }

  return new Scaffold(
     appBar: new AppBar(
      title: new Text('Add Buku'),
      backgroundColor:Colors.indigo
      ),
      body: new SingleChildScrollView(
         child: Padding(
          padding: const EdgeInsets.all(8.0),
            child:Form(
          key: _formKey,
          child: Column(
        children: <Widget>[
          TextFormField(
                controller: _judulController,
                textCapitalization: TextCapitalization.sentences,
                validator: (value){
                  if(value!.isEmpty){
                      return 'required field ';
                    }
                    return null;
                },
                onSaved: (String? value) {
                  formData['judul'] = value;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey
                  ),
                  labelText: 'Judul',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType:TextInputType.text
              ),
             SizedBox(height: 10),
             DropdownSearch<Genre>(
              items:widget.listgenre,
              onSaved: (Genre? value) {
                formData['genre'][0] = value!.id;
              },
              mode:Mode.BOTTOM_SHEET,
              validator: (Genre? u) => u == null ? "Genre field is required " : null,
              showSelectedItem: true,
              selectedItem: _genre,
              showClearButton: true,
                searchBoxDecoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                labelText: "Search a Genre",
              ),
              isFilteredOnline : false,
              filterFn: (_genre, filter) => _genre.genreFilterByName(filter),
              dropdownSearchDecoration: InputDecoration(
                  prefixIcon: Icon(Icons.local_gas_station),
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              compareFn: (Genre? i, Genre? s) => i!.isEqual(s),
              label: "choose a Genre",
              onChanged: (Genre? data) {
                _genre = data!;
              },
              showSearchBox: true,
              dropdownBuilder: _customDropDownLevel,
              popupItemBuilder: _customPopupItemBuilderLevel,
            ),
             SizedBox(height: 10),
              TextFormField(
                controller: _lokasiController,
                textCapitalization: TextCapitalization.sentences,
                validator: (value){
                  if(value!.isEmpty){
                      return 'required field ';
                    }
                    return null;
                },
                onSaved: (String? value) {
                  formData['lokasi'] = value;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey
                  ),
                  labelText: 'Lokasi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType:TextInputType.text
              ),
               SizedBox(height: 10),
            DropdownSearch<Pengarang>(
              items:widget.listpengarang,
              onSaved: (Pengarang? value) {
                formData['pengarang'][0] = value!.id;
              },
              mode:Mode.BOTTOM_SHEET,
              validator: (Pengarang? u) => u == null ? "Favorit field is required " : null,
              showSelectedItem: true,
              selectedItem: _penggarang,
              showClearButton: true,
                searchBoxDecoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                labelText: "Search a Pengarang",
              ),
              isFilteredOnline : false,
              filterFn: (_penggarang, filter) => _penggarang.pengarangFilterByName(filter),
              dropdownSearchDecoration: InputDecoration(
                  prefixIcon: Icon(Icons.local_gas_station),
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              compareFn: (Pengarang? i, Pengarang? s) => i!.isEqual(s),
              label: "choose a Pengarang",
              onChanged: (Pengarang? data) {
                _penggarang = data!;
              },
              showSearchBox: true,
              dropdownBuilder: _customDropDownLevel2,
              popupItemBuilder: _customPopupItemBuilderLevel2,
            ),
            SizedBox(height: 10),
            TextFormField(
                controller: controllerTahunterbit,
                textCapitalization: TextCapitalization.sentences,
                validator: (value){
                  if(value!.isEmpty){
                      return 'required field ';
                    }
                    return null;
                },
                onSaved: (String? value) {
                  formData['tahunTerbit'] = value;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.calendar_today,
                    color: Colors.grey
                  ),
                  labelText: 'Tahun Terbit',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType:TextInputType.number
              ),   
              SizedBox(height: 10),
            TextFormField(
                controller: _keywordController,
                textCapitalization: TextCapitalization.sentences,
                validator: (value){
                  if(value!.isEmpty){
                      return 'required field ';
                    }
                    return null;
                },
                onSaved: (String? value) {
                  formData['keyword'][0] = value;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey
                  ),
                  labelText: 'keyword',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType:TextInputType.text
              ),
               SizedBox(height: 10),  
              TextFormField(
                controller: _hargaController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.money,
                    color: Colors.grey,
                  ),
                  labelText: 'Harga',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType:TextInputType.number,
                validator: (value){
                  if(value!.isEmpty){
                      return 'required field ';
                    }
                    return null;
                },
                onSaved: (String? value) {
                  formData['harga'] = int.parse(value!);
                },
              ),  
               SizedBox(height: 10),  
              CheckboxListTile(
              title: const Text('Boleh Pinjam ?'),
              value: ispinjam,
              onChanged: (bool? value) {
                setState(() {
                  ispinjam = value!;
                  formData['pinjam'] = ispinjam ? 1 : 0;
                });
              },
              secondary: const Icon(Icons.card_membership),
            ),
              
              const SizedBox(height: 10),
              Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                         this._formKey.currentState!.save();

                            var token = await usertoken();

                            print(formData);

                         await EasyLoading.show(
                          status: 'loading...',
                          maskType: EasyLoadingMaskType.black,
                        );

                      await http.put(Uri.parse('https://soal.holywings.com/buku/${widget.buku.id}')
                        ,body: jsonEncode(formData)
                        , headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
                        'Authorization': 'Bearer $token',
                      }
                      ).timeout(Duration(seconds: 20)).catchError((error) async {
                        print(error);
                          await EasyLoading.showError(error.toString(),dismissOnTap: false);
                      }).then((value) async {
                        print(value.statusCode);
                          await EasyLoading.showSuccess('Success!',dismissOnTap: false);
                            finish();
                        });
                        
                      } else {
                        print("validation failed");
                      }
                    },
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "Reset",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                  ),
                ),
              ],
            )
          ],
          ),
        )
        )
      ),
      
    );
  }
}

