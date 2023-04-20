import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_notes/NoteSheets/speech_to_text_sheet.dart';
import 'package:my_notes/Screens/addNotePage/add_speech_page.dart';
import 'package:my_notes/Screens/notesPage/note_card.dart';
import 'package:my_notes/controllers/note_controller.dart';
import 'package:my_notes/controllers/speech_controller.dart';

import '../NoteSheets/image_entry_sheet.dart';
import '../NoteSheets/manuel_entry_sheet.dart';
import '../Screens/notesPage/image_card.dart';
import '../Screens/notesPage/manuel_card.dart';
import 'noteActionEnums.dart';

enum NoteTypeEnum {
  manuelNote,
  speechNote,
  imageNote,
  imageToTextNote,
  speechToTextNote
}

extension NoteTypeExtension on NoteTypeEnum {
  String noteTypeEnumToString() {
    return toString().split('.').last;
  }

  Future onSaveButtonPressed({String? noteTitle, String? noteText}) {
    switch (this) {
      case NoteTypeEnum.speechNote:
        return Get.find<SpeechController>()
            .onSaveButtonPressed(noteTitle: noteTitle);
      case NoteTypeEnum.imageNote:
        return Get.find<NoteController>().uploadNote(
            noteTitle: Get.find<NoteController>().noteTitleController.text,
            noteText: noteText ?? "",
            noteTypeEnum: NoteTypeEnum.imageNote,
            imagePath: Get.find<NoteController>().imagePath);
      case NoteTypeEnum.manuelNote:
        return Get.find<NoteController>()
            .uploadNote(noteText: "", noteTypeEnum: NoteTypeEnum.manuelNote);
      case NoteTypeEnum.speechToTextNote:
        return Get.find<NoteController>().uploadNote(
            noteText: "", noteTypeEnum: NoteTypeEnum.speechToTextNote);
      case NoteTypeEnum.imageToTextNote:
        return Get.find<NoteController>().uploadNote(
            noteText: "", noteTypeEnum: NoteTypeEnum.imageToTextNote);
    }
  }

  Future onEditButtonPressed({String? noteTitle, String? noteText}) {
    switch (this) {
      case NoteTypeEnum.speechNote:
        return Get.find<NoteController>()
            .editNote(noteTitle: noteTitle, noteText: noteText);
      case NoteTypeEnum.imageNote:
        return Get.find<NoteController>()
            .editNote(noteTitle: noteTitle, noteText: noteText);
      case NoteTypeEnum.manuelNote:
        return Get.find<NoteController>()
            .editNote(noteTitle: noteTitle, noteText: noteText);
      case NoteTypeEnum.speechToTextNote:
        return Get.find<NoteController>()
            .editNote(noteTitle: noteTitle, noteText: noteText);
      case NoteTypeEnum.imageToTextNote:
        return Get.find<NoteController>()
            .editNote(noteTitle: noteTitle, noteText: noteText);
    }
  }

  GestureDetector returnGestureDetectorWithSheet({required int i, required BuildContext context, required NoteAction noteAction }){
    NoteController noteController = Get.find<NoteController>();
    switch (this) {
      case NoteTypeEnum.speechNote:
        return GestureDetector(onTap: (){
            noteController.updateCurrentNote(noteController.noteList[i]);
            noteController.initTextEditingControllers(noteAction: noteAction, note: noteController.currentNote);
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return SizedBox(
                    height:
                    MediaQuery.of(context).size.height *
                        8 /
                        10,
                    width:
                    MediaQuery.of(context).size.width,
                    child: AddSpeechPage(noteAction: noteAction,),
                  );
                });

          }, child: NoteCard(note: noteController.noteList[i], index: i, onDelete: (){}, onView: (){}, onEdit: (){},),);
      case NoteTypeEnum.imageNote:
        /*return GestureDetector(child: Text("a"),);*/
        return GestureDetector(
            onTap: () {
              noteController.updateCurrentNote(noteController.noteList[i]);

              noteController.initTextEditingControllers(noteAction: noteAction);
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return SizedBox(
                      height:
                      MediaQuery.of(context).size.height *
                          8 /
                          10,
                      width:
                      MediaQuery.of(context).size.width,
                      child: ImageEntrySheet(noteAction: noteAction,),
                    );
                  });
            },
            child: ImageCard(
              note: noteController.noteList[i],
            ));
      case NoteTypeEnum.manuelNote:
          return GestureDetector(
              onTap: () {
                noteController.updateCurrentNote(noteController.noteList[i]);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return SizedBox(
                        height:
                        MediaQuery.of(context).size.height *
                            8 /
                            10,
                        width:
                        MediaQuery.of(context).size.width,
                        child: ManuelEntrySheet(noteAction: noteAction),
                      );
                    });
              },
              child: ManuelCard(
                note: noteController.noteList[i],
              ));
      case NoteTypeEnum.speechToTextNote:
        return GestureDetector(
            onTap: () {
              noteController.updateCurrentNote(noteController.noteList[i]);
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return SizedBox(
                      height:
                      MediaQuery.of(context).size.height *
                          8 /
                          10,
                      width:
                      MediaQuery.of(context).size.width,
                      child: ManuelEntrySheet(noteAction: noteAction),
                    );
                  });
            },
            child: ManuelCard(
              note: noteController.noteList[i],
            ));
      case NoteTypeEnum.imageToTextNote:
         return GestureDetector(
            onTap: () {
              noteController.updateCurrentNote(noteController.noteList[i]);
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return SizedBox(
                      height:
                      MediaQuery.of(context).size.height *
                          8 /
                          10,
                      width:
                      MediaQuery.of(context).size.width,
                      child: ManuelEntrySheet(noteAction: noteAction),
                    );
                  });
            },
            child: ManuelCard(
              note: noteController.noteList[i],
            ));
    }
  }
}
