import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<void> googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      final currentUser = FirebaseAuth.instance.currentUser;
      DocumentSnapshot ds = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser!.uid)
          .get();
      if (!ds.exists) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.uid)
            .set({
          "id": currentUser.uid,
          "email": user.email,
          "password": "",
          'name': "",
          'phoneNumber': "",
          'address': "",
          'imageUrl':
              "https://firebasestorage.googleapis.com/v0/b/test-login-df937.appspot.com/o/adopt_me_logo.png?alt=media&token=14ec5a26-fbbb-42fe-8828-a276295f5101"
        });
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future logOut() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
