
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_notes/Utils/TextStyleUtility.dart';
import 'package:my_notes/controllers/note_controller.dart';

import '../Models/Note.dart';
import '../Utils/ColorsUtility.dart';
import '../controllers/speech_controller.dart';
import '../enums/noteTypeEnums.dart';

class ImageDisplaySheetAppBar extends StatelessWidget implements PreferredSizeWidget {
  ImageDisplaySheetAppBar({
    Key? key,
    required this.noteTitleController,
    required this.noteTypeEnum,
  }) : super(key: key);

  final TextEditingController noteTitleController;
  final NoteTypeEnum noteTypeEnum;

  late final GetxController controller;



  @override
  Widget build(BuildContext context) {
    print("buillldd");
    //noteTitleController.text = note.noteTitle.toString() ?? "";
    //print(noteTypeEnum.index.toString());

    /*switch (noteTypeEnum) {
      case NoteTypeEnum.manuelNote:
        controller = Get.find<NoteController>();
        break;
      case NoteTypeEnum.speechNote:
        controller = Get.find<SpeechController>();
        break;
      case NoteTypeEnum.speechToTextNote:
        controller = Get.find<NoteController>();
        break;
      case NoteTypeEnum.imageToTextNote:
        controller = Get.find<NoteController>();
        break;
      case NoteTypeEnum.imageNote:
        controller = Get.find<NoteController>();
        break;
    }*/

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: ColorsUtility.blackThemeAppBarColor,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left),
        color: ColorsUtility.blackThemeAppBarIconColor,
        onPressed: () {
          Navigator.pop(context);
          Get.find<NoteController>().resetTextEditingControllers();
        },
      ),
      title: TextField(
        controller: Get.find<NoteController>().noteTitleController,
        decoration: InputDecoration(
            hintText: "Title",
            hintStyle: TextStyleUtility.hintTextStyle,

            labelStyle: TextStyle(color: ColorsUtility.whiteTextColor)),
        style: TextStyle(color: ColorsUtility.whiteTextColor),
      ),
      actions: [
        TextButton.icon(
            onPressed: () async {
              //await Get.find<NoteController>().editNote(noteTitle , note);
              //await speechController.onSaveButtonPressed();
              /*await noteTypeEnum.onSaveButtonPressed(
                  noteTitle:
                  Get.find<NoteController>().noteTitleController.text);*/
            },
            icon: Icon(
              Icons.edit,
              color: ColorsUtility.blackThemeAppBarIconColor,
            ),
            label: Text(
              "Edit",
              style: TextStyle(color: ColorsUtility.whiteTextColor),
            ))
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
