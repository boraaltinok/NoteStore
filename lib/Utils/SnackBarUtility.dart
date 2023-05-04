import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/FontSizeUtility.dart';


class SnackBarUtility {
  static void showCustomSnackbar({required String title, required String message, required Icon icon}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      backgroundColor: Colors.red,
      margin: EdgeInsets.all(FontSizeUtility.font20),
      duration: const Duration(seconds: 2),
      icon: icon,
      shouldIconPulse: true,
      overlayColor: Colors.black87.withOpacity(0.6),
      overlayBlur: 3,
      /*mainButton: TextButton(
        onPressed: () {},
        child: Text('Action'),
      ),*/
      snackStyle: SnackStyle.FLOATING,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 500),
      backgroundGradient: LinearGradient(
        colors: [ColorsUtility.gradientColor1 ?? Colors.black87, ColorsUtility.gradientColor2 ??Colors.black87],
      ),
      borderRadius: 10,
      borderWidth: 2,
      borderColor: Colors.white,
    );
  }

}