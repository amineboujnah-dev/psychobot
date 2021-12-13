import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:psychobot/core/constants/login_and_register_constants.dart';

import 'package:provider/provider.dart';
import 'package:psychobot/core/providers/authentication_provider.dart';
import 'package:psychobot/core/providers/google_sign_in_provider.dart';
import 'package:psychobot/ui/screens/Authentication/widgets/register_widget.dart';
import 'package:psychobot/ui/screens/menu/view/menu_view.dart';
import 'package:psychobot/ui/ui_utils/config_setup/size_config.dart';
import 'package:psychobot/ui/ui_utils/values/styles.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  late SizeConfig p;
  bool _isObscure = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthProvider>(context);
    final loginWithGoogleProvider = Provider.of<GoogleSignProvider>(context);
    final p = new SizeConfig();
    p.init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (loginProvider.errorMessage != "")
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      color: Colors.amberAccent,
                      child: ListTile(
                        title: Text(loginProvider.errorMessage),
                        leading: Icon(Icons.error),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              loginProvider.setMessage("");
                            });
                          },
                          icon: Icon(Icons.close),
                        ),
                      ),
                    ),
                  SizedBox(height: p.getProportionateScreenHeight(60)),
                  Text(
                    welcomeLabel,
                    style: welcomeLabelStyle,
                  ),
                  SizedBox(height: p.getProportionateScreenHeight(10)),
                  Text(
                    signInLabel,
                    style: authMsgslStyle,
                  ),
                  SizedBox(height: p.getProportionateScreenHeight(30)),
                  SizedBox(height: p.getProportionateScreenHeight(30)),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  SizedBox(height: p.getProportionateScreenHeight(30)),
                  TextFormField(
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return nullPasswordMsg;
                      } else if (value.length < 6) {
                        return lengthPasswordMsg;
                      }
                      return null;
                    },
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key),
                      hintText: pwdHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }),
                    ),
                  ),
                  SizedBox(height: p.getProportionateScreenHeight(30)),
                  MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        print("Email : ${_emailController.text}");
                        print("Password : ${_passwordController.text}");
                        final User? loginResponse = await loginProvider.login(
                            _emailController.text.trim(),
                            _passwordController.text.trim());
                        if (loginResponse != null) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => MenuView()));
                        }
                      }
                    },
                    height: p.getProportionateScreenHeight(70),
                    minWidth: loginProvider.isLoading ? null : double.infinity,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: loginProvider.isLoading
                        ? Center(
                            widthFactor: 3,
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          )
                        : Text(
                            loginLabel,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  //SizedBox(height: 30),
                  /*MaterialButton(
                    onPressed: () {
                      loginwithGoogleProvider.googleLogin();
                    },
                    height: p.getProportionateScreenHeight(70),
                    minWidth: loginProvider.isLoading ? null : double.infinity,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      signInWithGoogle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),*/

                  SizedBox(height: p.getProportionateScreenHeight(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(missingAccLabel),
                      SizedBox(width: p.getProportionateScreenWidth(5)),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => Register()));
                          });
                        },
                        child: Text(
                          registerLabel,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
