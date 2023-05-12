import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_notes/Utils/TextStyleUtility.dart';
import 'package:my_notes/controllers/book_controller.dart';
import 'package:my_notes/controllers/note_controller.dart';
import 'package:my_notes/enums/noteActionEnums.dart';

import '../Utils/ColorsUtility.dart';
import '../controllers/speech_controller.dart';
import '../enums/noteTypeEnums.dart';

class AddBookPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  AddBookPageAppBar({
    Key? key,
  }) : super(key: key);

  late final GetxController controller;

  BookController bookController = Get.put(BookController());

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left),
        color: ColorsUtility.appBarIconColor,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      /*title: TextField(
        decoration: InputDecoration(
          labelText: "Book Title",
          labelStyle: TextStyle(color: ColorsUtility.hintTextColor),
        ),
        style: TextStyle(color: ColorsUtility.blackText),
      ),*/
      actions: [
        TextButton.icon(
            onPressed: () async {
              final navigator = Navigator.of(context);

              //await speechController.onSaveButtonPressed();
              Get.find<BookController>().uploadBook(
                  bookName: bookController.bookTitleController.text,
                  bookAuthor: bookController.bookAuthorController.text,
                  isItScan: false,
                  bookCoverPath: bookController.bookManualPhoto?.path ?? "");
              navigator.pop();
            },
            icon: Icon(
              Icons.check_circle_outline,
              color: ColorsUtility.appBarIconColor,
            ),
            label: Text(
              "Save Book",
              style: TextStyle(color: ColorsUtility.appBarIconColor),
            )),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
