import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:psychobot/core/models/user_model.dart';

class UserService {
  final String uid;
  var downloadUrl;
  var _basename;
  UserService({required this.uid});

  // collection reference
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(
      String name, String phoneNumber, String address, String imageUrl) async {
    return await userCollection.doc(uid).update({
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'imageUrl': imageUrl
    });
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid,
        snapshot.get('name'),
        snapshot.get('email'),
        snapshot.get('phoneNumber'),
        snapshot.get('address'),
        snapshot.get('imageUrl'));
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future<void> uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile? image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);

      File file = new File(image!.path);
      _basename = basename(file.path);

      if (image != null) {
        //Upload to Firebase
        var snapshot =
            await _storage.ref().child('images/$_basename').putFile(file);

        downloadUrl = await snapshot.ref.getDownloadURL();
        print(downloadUrl);
      } else {
        print('No Path Received');
      }
    } else {
      print('Grant Permissions and try again');
    }
  }

  String get url => downloadUrl;

  String get fileName => _basename;
}
