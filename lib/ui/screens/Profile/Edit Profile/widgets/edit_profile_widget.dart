import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:psychobot/core/constants/drawer_configuration.dart';
import 'package:psychobot/core/constants/login_and_register_constants.dart';

import 'package:psychobot/core/services/user_service.dart';
import 'package:psychobot/ui/ui_utils/config_setup/size_config.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();
  // form values
  String _currentName = "";
  String _currentPhoneNumber = "";
  String _currentAddress = "";
  String _imageUrl = "";

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final currentUser = FirebaseAuth.instance.currentUser;
    final p = new SizeConfig();
    p.init(context);
    //UserModel? user = Provider.of<UserModel?>(context);
    UserService userService = UserService(uid: currentUser!.uid);
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
          future: users.doc(currentUser.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: ListView(
                      children: [
                        SizedBox(
                          height: p.getProportionateScreenHeight(15),
                        ),
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: p.getProportionateScreenWidth(140),
                                height: p.getProportionateScreenWidth(140),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: p.getProportionateScreenWidth(4),
                                      color: Theme.of(context).primaryColor),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      _imageUrl == ""
                                          ? data['imageUrl']
                                          : _imageUrl,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: p.getProportionateScreenWidth(44),
                                    width: p.getProportionateScreenWidth(44),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: p.getProportionateScreenWidth(4),
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      color: primaryGreen,
                                    ),
                                    child: IconButton(
                                      onPressed: () async {
                                        await userService.uploadImage();
                                        setState(() {
                                          _imageUrl = userService.url;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.add_photo_alternate,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(height: p.getProportionateScreenHeight(35)),
                        /*buildTextField("Full Name", "Dor Alex", false),
                    buildTextField("E-mail", "alexd@gmail.com", false),
                    buildTextField("Password", "********", true),
                    buildTextField("Address", "Tunisia, Sousse", false),*/
                        TextFormField(
                          initialValue: data['name'],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return nullNameMsg;
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() => _currentName = val);
                          },
                          decoration: InputDecoration(
                            hintText: "Full Name",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: p.getProportionateScreenHeight(30)),
                        /*TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !EmailValidator.validate(value)) {
                              return nullEmailMsg;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: emailHint,
                            prefixIcon: Icon(Icons.mail),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: p.getProportionateScreenHeight(30)),*/
                        TextFormField(
                          maxLength: 8,
                          initialValue: data['phoneNumber'],
                          keyboardType: TextInputType.phone,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          //controller: _phoneController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return nullPhoneMsg;
                            }
                            return null;
                          },
                          onChanged: (val) =>
                              setState(() => _currentPhoneNumber = val),
                          decoration: InputDecoration(
                            hintText: PhoneHint,
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: p.getProportionateScreenHeight(30)),
                        TextFormField(
                          initialValue: data['address'],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return nullAddressMsg;
                            }
                            return null;
                          },
                          onChanged: (val) =>
                              setState(() => _currentAddress = val),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_city),
                            hintText: addressHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: p.getProportionateScreenHeight(35),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("CANCEL",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.black)),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await UserService(uid: currentUser.uid)
                                      .updateUserData(
                                          _currentName == ""
                                              ? data['name']
                                              : _currentName,
                                          _currentPhoneNumber == ""
                                              ? data['phoneNumber']
                                              : _currentPhoneNumber,
                                          _currentAddress == ""
                                              ? data['address']
                                              : _currentAddress,
                                          _imageUrl == ""
                                              ? data['imageUrl']
                                              : _imageUrl);
                                  Navigator.pop(context);
                                }
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              child: Text(
                                "SAVE",
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold();
            }
          }),
    );
  }

  /*Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }*/
}
