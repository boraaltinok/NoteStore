import 'package:flutter/cupertino.dart';
import 'package:my_notes/Utils/FontSizeUtility.dart';

import 'ColorsUtility.dart';

class TextStyleUtility {
  static TextStyle textStyleBookInfoDialog = TextStyle(fontWeight: FontWeight.bold, color: ColorsUtility.blackText);

  static TextStyle textStyleManuelNoteText = TextStyle(fontWeight: FontWeight.normal, color: ColorsUtility.blackText);

  static TextStyle languageTextStyle = TextStyle(fontWeight: FontWeight.bold, color: ColorsUtility.blackText, fontSize: FontSizeUtility.font40);

  static TextStyle signUpFieldsTextStyle = TextStyle();

  static TextStyle textStyleNoteCardTitle = TextStyle(fontWeight: FontWeight.bold, color: ColorsUtility.whiteTextColor, fontSize: FontSizeUtility.font15);

  static TextStyle textStyleDate = TextStyle(color: ColorsUtility.whiteTextColor);

  static TextStyle hintTextStyle =  TextStyle(color: ColorsUtility.hintTextColor, fontWeight: FontWeight.bold);

  static TextStyle profileInfoTextStyle = TextStyle(color: ColorsUtility.whiteTextColor);

  static TextStyle headingTextStyle = TextStyle(color: ColorsUtility.blackText, fontWeight: FontWeight.bold, fontSize: FontSizeUtility.font30);

  static TextStyle dangerTextStyle = TextStyle(color: ColorsUtility.redColor, fontWeight: FontWeight.bold);

}