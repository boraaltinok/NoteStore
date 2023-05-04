import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_notes/Screens/splash/blank_empty_screen.dart';

import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/LocalizationUtility.dart';
import 'package:my_notes/controllers/connectivity_controller.dart';
import 'package:my_notes/controllers/language_controller.dart';
import 'package:my_notes/lang/languages.dart';

import 'controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //var connectivityResult = await (Connectivity().checkConnectivity());

  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
    Get.put(LanguageController());
    Get.put(ConnectivityController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Languages(),
      locale: Get.find<LanguageController>().selectedLanguageIndex == -1
          ? Get.deviceLocale
          : Get.find<LanguageController>()
              .languages[Get.find<LanguageController>().selectedLanguageIndex],
      fallbackLocale: LocalizationUtility.EN_LOCALE,

      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: ColorsUtility.scaffoldBackgroundColor,
          appBarTheme: AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle.light
                  .copyWith(statusBarColor: Colors.black),
              centerTitle: true,
              titleTextStyle:
                  const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              backgroundColor: ColorsUtility.appBarBackgroundColor,
              elevation: 5),
          floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
              backgroundColor: ColorsUtility.appBarIconColor,
              foregroundColor: ColorsUtility.floatingButtonForegroundColor)),
      //home: const MyHomePage(),
      //home: const BookNotes(),
      home: const BlankEmptyScreen(), // bunla çalıştıırcan
      //home: const ScanBookPage(),
    );
  }
}
