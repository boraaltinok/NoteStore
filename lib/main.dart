import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_notes/Screens/no_connection_page.dart';
import 'package:my_notes/Screens/splash/blank_empty_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:my_notes/Screens/bookPage/books_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_notes/Screens/splash/splash_screen.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/LocalizationUtility.dart';
import 'package:my_notes/constants.dart';
import 'package:my_notes/controllers/connectivity_controller.dart';

import 'controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  var connectivityResult = await (Connectivity().checkConnectivity());

  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
    Get.put(ConnectivityController());
  });
  runApp(EasyLocalization(
      supportedLocales: const [LocalizationUtility.EN_LOCALE],
      path: LocalizationUtility.LANG_PATH,
      fallbackLocale: LocalizationUtility.EN_LOCALE,
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      //localizationsDelegates: context.localizationDelegates,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

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
