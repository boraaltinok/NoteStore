import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:my_notes/Utils/FontSizeUtility.dart';
class PaddingUtility {

  static EdgeInsets scaffoldBodyGeneralPadding = EdgeInsets.all(FontSizeUtility.font15);//16.00
  static EdgeInsets paddingTop10 = EdgeInsets.only(top: FontSizeUtility.font10);
  static EdgeInsets paddingTop20 = EdgeInsets.only(top: FontSizeUtility.font20);
  static EdgeInsets paddingTop30 = EdgeInsets.only(top: FontSizeUtility.font30);
  static EdgeInsets scaffoldGeneralPaddingOnlyTRL = EdgeInsets.only(top: FontSizeUtility.font15, right: FontSizeUtility.font15, left: FontSizeUtility.font15);

  static EdgeInsets paddingTransparentCardArea = EdgeInsets.all(FontSizeUtility.font15 / 2);

  static EdgeInsets paddingTextLeftRight = EdgeInsets.only(right: FontSizeUtility.font15 / 2, left: FontSizeUtility.font15 / 2);

  static EdgeInsets dialogGeneralPadding = EdgeInsets.all(FontSizeUtility.font10);



}