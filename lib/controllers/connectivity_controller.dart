import 'dart:async';

import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:my_notes/Screens/no_connection_page.dart';
import 'package:my_notes/Screens/splash/splash_screen.dart';

class ConnectivityController extends GetxController{
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
      if(_isConnected.value == false){
        Get.offAll(() => const NoConnectionPage());
      }
    });
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _isConnected.value = connectivityResult != ConnectivityResult.none;
  }


}