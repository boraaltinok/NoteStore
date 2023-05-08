import 'dart:async';

import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:my_notes/Screens/bookPage/books_page.dart';
import 'package:my_notes/Screens/no_connection_page.dart';
import 'package:my_notes/Screens/splash/splash_screen.dart';

import '../Screens/auth/login_screen.dart';
import '../Screens/auth/signup_screen.dart';
import '../constants.dart';

class ConnectivityController extends GetxController {
  static ConnectivityController instance = Get.find();

  final Connectivity _connectivity = Connectivity();
  final _isConnected = false.obs;

  bool get isConnected => _isConnected.value;

  @override
  void onInit() {
    super.onInit();
    checkConnectivity();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _isConnected.value = result != ConnectivityResult.none;
      if (_isConnected.value == false) {
        Get.offAll(() => const NoConnectionPage());
      } else if (_isConnected.value == true) {
        if (firebaseAuth.currentUser == null) {
          print("here3");
          //Get.offAll(() => SignUpScreen());
          Get.offAll(() => LoginScreen());

        } else {
          Get.offAll(() => const BooksPage());
          print("else connectivity");
          //Get.offAll(() => SignUpScreen());
        }
      }
    });
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _isConnected.value = connectivityResult != ConnectivityResult.none;
    if (connectivityResult == ConnectivityResult.none) {
      //Get.offAll(() => const NoConnectionPage());
      return false;
    } else {
      //Get.offAll(() => const BooksPage());
      return true;
    }
  }
}
