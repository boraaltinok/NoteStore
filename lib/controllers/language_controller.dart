import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_notes/Utils/LocalizationUtility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/SnackBarUtility.dart';
import '../../lang/translation_keys.dart' as translation;
import 'package:my_notes/extensions/string_extension.dart';

class LanguageController extends GetxController {

  int selectedLanguageIndex = -1;
  List<Locale> languages = [
    LocalizationUtility.TR_LOCALE,
    LocalizationUtility.EN_LOCALE,
    LocalizationUtility.RU_LOCALE
  ];

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedLanguageIndex = prefs.getInt('selectedLanguageIndex') ?? -1;

  }

  void changeLanguage({required Locale locale}) async {
    Get.updateLocale(locale);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int newLanguageIndex = languages.indexOf(locale);
    await prefs.setInt('selectedLanguageIndex', newLanguageIndex);

    SnackBarUtility.showCustomSnackbar(
      title: translation.success.locale,
      message: translation.languageChanged.locale,
      icon: const Icon(Icons.language),

    );
    //Get.back();

    update();
  }
}
