import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_notes/Screens/splash/splash_screen.dart';
import 'package:my_notes/Models/user.dart' as userModel;
import 'package:image_picker/image_picker.dart';
import 'package:my_notes/Screens/bookPage/books_page.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/SnackBarUtility.dart';

import '../Screens/auth/login_screen.dart';
import '../constants.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<File?> _pickedImage = null
      .obs; //this is observable keeps track if the image variable is changed or not
  late Rx<User?> _user; // this is not model user this is FİREBASE AUTH USER
  Rx<String> profilePhotoPath = "".obs;

  File? get profilePhoto => _pickedImage.value;

  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth
        .authStateChanges()); //whenever authStateChanges user value will also change = binding
    ever(_user,
        _setInitialScreen); //whenever there is change in the user call _setInitialScreen method
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      //Get.offAll(() => LoginScreen());
      Get.offAll(() => const SplashScreen());
    } else {
      print('UID IS : ${user.uid}');
      Get.offAll(() => const SplashScreen());
    }
  }

  //upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  //pick Image
  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      SnackBarUtility.showCustomSnackbar(title: "Profile Picture", message: "Successfully selected profile picture", icon: Icon(Icons.check_circle_outline));
    }
    print(_pickedImage.value?.path ?? "else");
    _pickedImage = Rx<File?>(File(pickedImage!.path));
    profilePhotoPath.value = pickedImage!.path;
    refresh();
  }

  //registering user
  Future<void> registerUser(String username, String email, String password, String verifyPassword,
      File? image, String country, String gender) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          verifyPassword.isNotEmpty
          /*image != null &&*/
          /*country.isNotEmpty &&
          gender.isNotEmpty*/) {
        //save our user to our auth and firebase database(firestore)
        if(password != verifyPassword){
          SnackBarUtility.showCustomSnackbar(title: 'Password Error', message: 'Passwords do not match', icon:  Icon(Icons.error_outline_outlined, color: ColorsUtility.redColor,));
        }else{
          UserCredential credential = await firebaseAuth
              .createUserWithEmailAndPassword(email: email, password: password);
          String downloadUrl = "";
          if(image != null){
            downloadUrl = await _uploadToStorage(image);
          }
          userModel.User user = userModel.User(
              name: username,
              uid: credential.user!.uid,
              email: email,
              profilePhoto: downloadUrl,
              country: country,
              gender: gender);

          firestore
              .collection('users')
              .doc(credential.user!.uid)
              .set(user.toJson());
          SnackBarUtility.showCustomSnackbar(title: 'Success', message: 'Account Created', icon:  Icon(Icons.check_circle_outline, color: ColorsUtility.appBarIconColor,));

        }

      } else {
        SnackBarUtility.showCustomSnackbar(title: 'Field Error', message: 'Please enter all fields', icon:  Icon(Icons.error_outline_outlined, color: ColorsUtility.redColor));
      }
    } catch (e) {
      SnackBarUtility.showCustomSnackbar(title: 'Error signing up', message: e.toString(), icon:  Icon(Icons.error_outline_outlined, color: ColorsUtility.redColor));
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print('log success');
      } else {
        SnackBarUtility.showCustomSnackbar(title: 'Error', message: 'Fields can not be empty', icon:  Icon(Icons.error_outline_outlined, color: ColorsUtility.redColor));
      }
    } catch (e) {
      SnackBarUtility.showCustomSnackbar(title: 'Error logging in', message: e.toString(), icon:  Icon(Icons.error_outline_outlined, color: ColorsUtility.redColor));
    }
  }
  //Google Sign In
  signInWithGoogle() async {
    //begin interactive sign in
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain auth details from the request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken
    );

    //get user details
    final String name = gUser.displayName ?? '';
    final String email = gUser.email ?? '';
    final String photoUrl = gUser.photoUrl ?? '';


    //finally, lets sign in
    final UserCredential userCredential =  await firebaseAuth.signInWithCredential(credential);
    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
    final DocumentSnapshot userDoc = await usersCollection.doc(userCredential.user?.uid).get();

    if (!userDoc.exists) {
      print("inside does not exists");
      userModel.User user = userModel.User(
          name: name,
          uid: userCredential.user!.uid ,
          email: email,
          profilePhoto: "",
          country: "",
          gender: "");

      firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toJson());
    }
  }

  Future<userModel.User?> getUser({required userId}) async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('users').doc(userId).get();

      userModel.User user = userModel.User.fromSnap(doc);

      return user;
    } catch (e) {
      Get.snackbar('Error Retrieving', e.toString());
      return null;
      /*return  userModel.User(
          name: "",
          uid: "",
          email: "",
          profilePhoto: "",
          country: "",
          gender: "");*/
    }
  }

  signOut() async {
    await firebaseAuth.signOut();
  }
}
