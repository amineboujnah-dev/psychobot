import 'dart:async';

import 'package:flutter/material.dart';
import 'package:psychobot/ui/screens/Home/view/home_view.dart';
import 'package:psychobot/ui/ui_utils/config_setup/size_config.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomeView()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = new SizeConfig();
    p.init(context);
    return Scaffold(
      //backgroundColor: primaryGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: p.getProportionateScreenHeight(300),
            ),
            SizedBox(
              height: p.getProportionateScreenHeight(20),
            ),
          ],
        ),
      ),
    );
  }
}
