import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_notes/Screens/splash/blank_empty_screen.dart';

import 'package:my_notes/Screens/bookPage/books_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_notes/Screens/splash/splash_screen.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';

import 'constants.dart';
import 'controllers/auth_controller.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  //0xff3EC4BD AÇIK MAVI
  //#00386B KOYU MAVI
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ColorsUtility.scaffoldBackgroundColor,
        appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light
                .copyWith(statusBarColor: Colors.black),
            centerTitle: true,
            titleTextStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            backgroundColor: ColorsUtility.appBarBackgroundColor,
            elevation: 5),
      ),
      //home: const MyHomePage(),
      //home: const BookNotes(),
      home: const BlankEmptyScreen(), // bunla çalıştıırcan
      //home: const ScanBookPage(),
    );
  }
}
