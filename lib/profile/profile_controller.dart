import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class Utils {
  static void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class ProfileController with ChangeNotifier {
  final picker = ImagePicker();
  late String userID;
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('members');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  XFile? _image;
  XFile? get image => _image;

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future pickGalleryImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      notifyListeners();
      uploadImage(context);
    }
  }

  Future pickCameraImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadImage(context);
      notifyListeners();
    }
  }

  void pickImage({required String userId, required BuildContext context}) {
    userID = userId;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      pickCameraImage(context);
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.camera),
                    title: Text('Camera'),
                  ),
                  ListTile(
                    onTap: () {
                      pickGalleryImage(context);
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.image),
                    title: Text('Gallery'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> uploadImage(BuildContext context) async {
    setLoading(true);

    try {
      // Reference to Firebase Storage
      firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref('/profileImage/$userID');

      // Upload the file to Firebase Storage
      firebase_storage.UploadTask uploadTask =
          storageRef.putFile(File(image!.path).absolute);

      await uploadTask;

      // Get the download URL
      final newURL = await storageRef.getDownloadURL();
      print('this is hell');
      // Update Firestore with the new profile image URL
      //  await ref.doc(userID).update({'profile': newURL.toString()});
      await FirebaseFirestore.instance
          .collection('members')
          .doc(userID)
          .update({'profile': newURL.toString()});

      Utils.toastMessage('Profile updated');
      _image = null;
    } catch (error) {
      Utils.toastMessage(error.toString());
    } finally {
      setLoading(false);
    }
  }
}
