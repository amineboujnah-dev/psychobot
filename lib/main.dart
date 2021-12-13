import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:psychobot/core/models/user_model.dart';
import 'package:psychobot/core/providers/google_sign_in_provider.dart';
import 'package:psychobot/core/providers/authentication_provider.dart';
import 'package:psychobot/core/providers/menu_provider.dart';
import 'package:psychobot/ui/screens/SplashScreen/view/splash_screen_view.dart';
import 'package:psychobot/core/constants/drawer_configuration.dart';
import 'package:provider/provider.dart';

import 'core/providers/menu_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _init = Firebase.initializeApp();
    return FutureBuilder(
        future: _init,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  Icon(Icons.error),
                  Text('Something went wrong !'),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthProvider>.value(
                    value: AuthProvider()),
                ChangeNotifierProvider<GoogleSignProvider>.value(
                    value: GoogleSignProvider()),
                ChangeNotifierProvider<MenuProvider>.value(
                    value: MenuProvider()),
                StreamProvider<UserModel?>.value(
                    value: AuthProvider().user, initialData: UserModel("")),
              ],
              child: MaterialApp(
                theme: ThemeData(
                  primaryColor: primaryGreen,
                ),
                debugShowCheckedModeBanner: false,
                home: SplashScreen(),
              ),
            );
          } else {
            return SplashScreen();
          }
        });
  }
}
