import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Utils/ColorsUtility.dart';
import '../Utils/LocalizationUtility.dart';
import '../Utils/SnackBarUtility.dart';
import '../Utils/TextStyleUtility.dart';
import '../controllers/language_controller.dart';
class SelectLanguagePopUp extends StatelessWidget {
  SelectLanguagePopUp({
    Key? key,
  }) : super(key: key);


  final Country? turkey = Country.tryParse('turkey');
  final Country? us = Country.tryParse('us');
  final Country? russia = Country.tryParse('russia');

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color:
              ColorsUtility.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.all(
                  Radius.circular(20))),
          height: Get.height * 4 / 10,
          width: Get.width * 7 / 10,
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                      behavior: HitTestBehavior.translucent,

                      onTap: () {
                        Get.find<LanguageController>()
                            .changeLanguage(
                            locale: LocalizationUtility
                                .TR_LOCALE);
                        Navigator.pop(context);
                      },
                      child: SizedBox(

                        child: AutoSizeText(
                          "${turkey?.flagEmoji ?? ""} TURKISH",
                          style: TextStyleUtility
                              .languageTextStyle,
                        ),
                      )),
                ),
              ),
              Divider(
                thickness: 3.0,
                color: ColorsUtility.blackText,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,

                    onTap: () {
                      Get.find<LanguageController>()
                          .changeLanguage(
                          locale: LocalizationUtility
                              .EN_LOCALE);
                      Navigator.pop(context);
                    },
                    child: AutoSizeText(
                      "${us?.flagEmoji ?? ""} ENGLISH",
                      style: TextStyleUtility
                          .languageTextStyle,
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 3.0,
                color: ColorsUtility.blackText,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,

                    onTap: () {
                      Get.find<LanguageController>()
                          .changeLanguage(
                          locale: LocalizationUtility
                              .RU_LOCALE);
                      Navigator.pop(context);
                    },
                    child: AutoSizeText(
                      "${russia?.flagEmoji ?? ""} RUSSIAN",
                      style: TextStyleUtility
                          .languageTextStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}