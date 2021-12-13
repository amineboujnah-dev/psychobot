import 'package:flutter/material.dart';
import 'package:psychobot/ui/screens/Authentication/widgets/login_widget.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return Login();
  }
}
