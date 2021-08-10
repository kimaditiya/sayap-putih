import 'dart:async';
import 'dart:convert';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sayap_putih/models/genre.dart';
import 'package:sayap_putih/models/member.dart';
import 'package:sayap_putih/models/pengarang.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FormMember extends StatefulWidget {

   final PagingController<int, Member> paging;

  final List<Genre> listgenre;

  final List<Pengarang> listpengarang;

  FormMember({Key? key, required this.paging,required this.listgenre,required this.listpengarang}) : super(key: key);


  @override
  _FormMemberState createState() => _FormMemberState();
}

class _FormMemberState extends State<FormMember> {

  final TextEditingController controllerTglLahir = new TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  

  Timer? _timer;
  final _formKey = GlobalKey<FormState>();
  Genre? _genre;
  Pengarang? _penggarang;


  final Map<String, dynamic> formData = {
     "alamat": "",
      "genreFavorit": [
        0
      ],
      "nama": "",
      "pengarangFavorit": [
        0
      ],
      "tanggalLahir": ""
  };

  Future<String?> usertoken() async {
      // Read value 
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
   

    return token;

  }


      @override
  void initState() {
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
      title: new Text('Add Member'),
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
                controller: _alamatController,
                textCapitalization: TextCapitalization.sentences,
                validator: (value){
                  if(value!.isEmpty){
                      return 'required field ';
                    }
                    return null;
                },
                onSaved: (String? value) {
                  formData['alamat'] = value;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey
                  ),
                  labelText: 'Alamat',
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
                formData['genreFavorit'][0] = value!.id;
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
                controller: _namaController,
                textCapitalization: TextCapitalization.sentences,
                validator: (value){
                  if(value!.isEmpty){
                      return 'required field ';
                    }
                    return null;
                },
                onSaved: (String? value) {
                  formData['nama'] = value;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey
                  ),
                  labelText: 'Nama',
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
                formData['pengarangFavorit'][0] = value!.id;
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
               DateTimePicker(
                type: DateTimePickerType.date,
                dateLabelText: 'Date',
                dateMask: 'yyyy-MM-dd',
                controller: controllerTglLahir,
                validator: (value){
                  if(value!.isEmpty){
                      return 'required field ';
                    }
                    return null;
                },
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.event),
                  labelText: 'Tanggal Lahir',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                onSaved: (String? value) {
                  formData['tanggalLahir'] = value;
                },
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

                      await http.post(Uri.parse('https://soal.holywings.com/member/')
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

