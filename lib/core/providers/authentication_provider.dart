import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:psychobot/core/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = "";
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // create user obj based on firebase user
  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel(user.uid) : null;
  }

  Stream<UserModel?> get user {
    return firebaseAuth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
    //.map(_userFromFirebaseUser);
  }

  Future register(String email, String password) async {
    setLoading(true);
    try {
      UserCredential authResult = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;

      if (user != null) {
        FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "id": user.uid,
          "email": email,
          "password": password,
          'name': "",
          'phoneNumber': "",
          'address': "",
          'imageUrl':
              "https://firebasestorage.googleapis.com/v0/b/test-login-df937.appspot.com/o/adopt_me_logo.png?alt=media&token=14ec5a26-fbbb-42fe-8828-a276295f5101"
        });
      }
      setLoading(false);
      return user;
    } on SocketException {
      setLoading(false);
      setMessage("No internet, please connect to the internet");
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      print(e.message);
      setMessage(e.message);
    }
    notifyListeners();
  }

  Future<User?> login(String email, String password) async {
    try {
      setLoading(true);
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = authResult.user;
      setLoading(false);
      return user;
    } on SocketException {
      setLoading(false);
      setMessage("No internet, please connect to the internet");
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      print(e.message);
      setMessage(e.message);
    }
    notifyListeners();
  }

  Future logout() async {
    await firebaseAuth.signOut();
  }

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  void setMessage(message) {
    _errorMessage = message;
    notifyListeners();
  }

  // GET UID
  String getCurrentUID() {
    return firebaseAuth.currentUser!.uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return firebaseAuth.currentUser;
  }
}
