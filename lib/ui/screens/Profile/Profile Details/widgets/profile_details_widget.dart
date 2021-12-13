import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:psychobot/core/constants/drawer_configuration.dart';
import 'package:psychobot/ui/screens/Profile/Edit%20Profile/view/edit_profile_view.dart';
import 'package:psychobot/ui/screens/menu/widgets/menu_icon_widget.dart';
import 'package:psychobot/ui/ui_utils/config_setup/size_config.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final currentUser = FirebaseAuth.instance.currentUser;
    final sizeConfig = SizeConfig();
    sizeConfig.init(context);
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: sizeConfig.getProportionateScreenHeight(50),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      MenuIconWidget(),
                      SizedBox(
                        width: sizeConfig.getProportionateScreenWidth(100),
                      ),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.userAlt,
                            color: primaryGreen,
                          ),
                          SizedBox(
                            width: sizeConfig.getProportionateScreenWidth(5),
                          ),
                          Text(
                            'Profile',
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: sizeConfig.getProportionateScreenHeight(30),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: sizeConfig.getProportionateScreenHeight(140),
                          width: sizeConfig.getProportionateScreenWidth(140),
                          //margin: EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width:
                                    sizeConfig.getProportionateScreenWidth(5),
                                color: Theme.of(context).primaryColor),
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                                image: NetworkImage(data['imageUrl'])),
                          ),
                        ),
                        SizedBox(
                          height: sizeConfig.getProportionateScreenHeight(20),
                        ),
                        Text(
                          data['name'],
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          data['email'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context).accentColor,
                          ),
                          child: ElevatedButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfileView())),
                            child: Text(
                              "EDIT PROFILE",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 1,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.person),
                                title: Text('Name'),
                                subtitle: Text(data['name']),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.black,
                              ),
                              ListTile(
                                leading: Icon(Icons.email),
                                title: Text('Email'),
                                subtitle: Text(data['email']),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.black,
                              ),
                              ListTile(
                                leading: Icon(Icons.phone),
                                title: Text('Phone Number'),
                                subtitle: Text(data['phoneNumber']),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.black,
                              ),
                              ListTile(
                                leading: Icon(Icons.location_city),
                                title: Text('Address'),
                                subtitle: Text(data['address']),
                              ),
                              SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          backgroundColor: primaryGreen,
          body: Center(
            child: SpinKitFadingCube(
              color: Colors.white,
              size: 80.0,
            ),
          ),
        );
      },
    );
  }
}
