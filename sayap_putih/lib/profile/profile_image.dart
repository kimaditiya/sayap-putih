import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final double height, width;
  final Color color;
  ProfileImage(
      {this.height = 100.0, this.width = 100.0, this.color = Colors.white});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
        image: DecorationImage(
          image: AssetImage("assets/avatar.jpg"),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: color,
          width: 3.0,
        ),
      ),
    );
  }
}