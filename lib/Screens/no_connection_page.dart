import 'package:flutter/material.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/PaddingUtility.dart';
import 'package:my_notes/Utils/TextStyleUtility.dart';

class NoConnectionPage extends StatelessWidget {
  const NoConnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtility.scaffoldBackgroundColor,
      body: Padding(
        padding: PaddingUtility.scaffoldBodyGeneralPadding,
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 6 / 10,
            width: MediaQuery.of(context).size.width,
            child: TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.wifi_off_outlined,
                  color: ColorsUtility.appBarIconColor,
                ),
                label: Text("Check you internet connection", style: TextStyleUtility.textStyleBookInfoDialog,)),
          ),
        ),
      ),
    );
  }
}
