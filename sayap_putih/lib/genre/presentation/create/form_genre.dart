import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sayap_putih/models/genre.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormGenre extends StatefulWidget {

  final PagingController<int, Genre> paging;

  FormGenre({Key? key, required this.paging}) : super(key: key);


  @override
  _FormGenreState createState() => _FormGenreState();
}

class _FormGenreState extends State<FormGenre> {

  final TextEditingController _namaController = TextEditingController();
  
  Timer? _timer;
  final _formKey = GlobalKey<FormState>();


  final Map<String, dynamic> formData2 = {
    'name': ""
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


  return new Scaffold(
     appBar: new AppBar(
      title: new Text('Add Genre'),
      backgroundColor:Colors.deepPurple
      ),
      body: new SingleChildScrollView(
         child: Padding(
          padding: const EdgeInsets.all(8.0),
            child:Form(
          key: _formKey,
          child: Column(
        children: <Widget>[
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
                  formData2['name'] = value;
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

                         _timer?.cancel();

                         await EasyLoading.show(
                          status: 'loading...',
                          maskType: EasyLoadingMaskType.black,
                        );

                         var formData = FormData.fromMap({
                            'name': formData2['name']
                          });

                        Dio dio = new Dio();
                        dio.options.headers["Authorization"] = "Bearer ${token}";

                      await dio.post('https://soal.holywings.com/genre', data: formData
                       
                      ).timeout(Duration(seconds: 20))
                      .catchError((error) async {

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




