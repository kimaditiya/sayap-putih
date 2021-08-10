import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

  class BukuSearchInput extends StatelessWidget {

    BukuSearchInput({
      Key? key,
    })  : super(key: key);

    final TextEditingController controller = new TextEditingController();

    @override
    Widget build(BuildContext context) =>  Card(
      color: Colors.white,
      child: new ListTile(
        leading: new Icon(Icons.search),
        title: new GestureDetector(
        child: new IgnorePointer(
          child: new TextField(
          controller: controller,
          decoration: new InputDecoration(
              hintText: 'Search', border: InputBorder.none)
        ))),
        onTap: () {
            
          },
      ),
    );
  }