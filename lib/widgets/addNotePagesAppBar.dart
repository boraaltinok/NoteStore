import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_notes/Utils/TextStyleUtility.dart';
import 'package:my_notes/controllers/note_controller.dart';
import 'package:my_notes/enums/noteActionEnums.dart';

import '../Utils/ColorsUtility.dart';
import '../controllers/speech_controller.dart';
import '../enums/noteTypeEnums.dart';
import '../../lang/translation_keys.dart' as translation;
import 'package:my_notes/extensions/string_extension.dart';

class AddNoteSheetsAppBar extends StatelessWidget with PreferredSizeWidget {
  AddNoteSheetsAppBar(
      {Key? key,
      required this.noteTitleController,
      required this.noteTypeEnum,
      required this.noteAction})
      : super(key: key);

  final TextEditingController noteTitleController;
  final NoteTypeEnum noteTypeEnum;
  final NoteAction noteAction;

  late final GetxController controller;

  @override
  Widget build(BuildContext context) {
    switch (noteTypeEnum) {
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
    }

    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left),
        color: ColorsUtility.appBarIconColor,
        onPressed: () {
          Navigator.pop(context);
          Get.find<NoteController>().resetTextEditingControllers();
        },
      ),
      title: TextField(
        controller: Get.find<NoteController>().noteTitleController,
        decoration: InputDecoration(
          labelText:
              translation.title.locale,
          labelStyle: TextStyle(color: ColorsUtility.hintTextColor),
        ),
        style: TextStyle(color: ColorsUtility.blackText),
      ),
      actions: [
        TextButton.icon(
            onPressed: () async {
              final navigator = Navigator.of(context);
              navigator.pop();

              //await speechController.onSaveButtonPressed();
              if (noteAction == NoteAction.noteAdd) {
                await noteTypeEnum.onSaveButtonPressed(
                    noteTitle:
                        Get.find<NoteController>().noteTitleController.text);
              } else if (noteAction == NoteAction.noteEdit) {
                await noteTypeEnum.onEditButtonPressed(
                    noteTitle:
                        Get.find<NoteController>().noteTitleController.text,
                    noteText: Get.find<NoteController>()
                        .noteTextEditingController
                        .text);
              }
            },
            icon: noteAction.returnNoteActionIcon(),
            label: noteAction.returnNoteActionIconLabel()),
        if (noteAction == NoteAction.noteEdit)
          IconButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                navigator.pop();
                await Get.find<NoteController>()
                    .deleteNote(note: Get.find<NoteController>().currentNote);
              },
              icon: Icon(
                Icons.delete,
                color: ColorsUtility.appBarIconColor,
              ))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
