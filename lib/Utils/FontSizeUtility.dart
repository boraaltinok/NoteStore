import 'package:get/get.dart';

class FontSizeUtility {
  static double screenHeight = Get.context!.height;//2400
  static double screenWidth = Get.context!.width;//1080

  static double galaxyA51HeightPixels = 915;
  static double galaxyA51WidthPixels = 412;


  static double font10 = screenHeight * (10 /galaxyA51HeightPixels );
  static double font15 = screenHeight * (15 /galaxyA51HeightPixels );
  static double font20 = screenHeight * (20 /galaxyA51HeightPixels );
  static double font25 = screenHeight * (25 /galaxyA51HeightPixels );
  static double font30 = screenHeight * (30 /galaxyA51HeightPixels );
  static double font35 = screenHeight * (35 /galaxyA51HeightPixels );
  static double font40 = screenHeight * (40 /galaxyA51HeightPixels );

}