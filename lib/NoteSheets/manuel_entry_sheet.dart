import 'package:flutter/material.dart';
import 'package:my_notes/enums/noteActionEnums.dart';

import '../Utils/ColorsUtility.dart';
import '../Utils/PaddingUtility.dart';
import '../controllers/note_controller.dart';
import '../enums/noteTypeEnums.dart';
import '../widgets/addNotePagesAppBar.dart';
import 'package:get/get.dart';
class ManuelEntrySheet extends StatefulWidget {
  const ManuelEntrySheet({
    Key? key,
    required this.noteAction
  }) : super(key: key);

  final NoteAction noteAction;

  @override
  State<ManuelEntrySheet> createState() => _ManuelEntrySheetState();
}

class _ManuelEntrySheetState extends State<ManuelEntrySheet> {

  NoteController noteController = Get.find<NoteController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.noteAction == NoteAction.noteEdit){
      noteController.initTextEditingControllers(noteAction: widget.noteAction, note: noteController.currentNote);
    }else if(widget.noteAction == NoteAction.noteAdd){
      noteController.initTextEditingControllers(noteAction: widget.noteAction);
    }
    //Get.find<NoteController>().initTextEditingControllers(noteAction: widget.noteAction, note: Get.find<NoteController>().currentNote);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Get.find<NoteController>().disposeTextEditingControllers();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddNoteSheetsAppBar(
        noteAction: widget.noteAction,
        noteTitleController: Get.find<NoteController>().noteTitleController,
        noteTypeEnum: NoteTypeEnum.manuelNote,
      ),
      body: Padding(
        padding: PaddingUtility.scaffoldBodyGeneralPadding,
        child: Column(
          children: [
            Expanded(
                child: TextField(
                  controller:
                  Get.find<NoteController>().noteTextEditingController,
                  keyboardType: TextInputType.multiline,
                  //maxLines: 10,
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText: "Write your note here",
                      hintStyle: TextStyle(color: ColorsUtility.hintTextColor),
                      border: InputBorder.none),
                  style: TextStyle(color: ColorsUtility.blackText),
                ))
          ],
        ),
      ),
    );
  }
}