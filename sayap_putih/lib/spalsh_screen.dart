import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:sayap_putih/login_screen.dart';

class Splash extends StatelessWidget {

  final userlog;

  Splash({this.userlog});

  @override
  Widget build(BuildContext context) {
    return SplashScreen.navigate(
      name: "assets/intro.flr",
      next: (_) => LoginScreen(),
      alignment: Alignment.center,
      until: () => Future.delayed(Duration(seconds: 0)),
      backgroundColor: Colors.deepPurple,
      startAnimation: '1',
      loopAnimation: '1',
      endAnimation: '1'
    );
  }
}