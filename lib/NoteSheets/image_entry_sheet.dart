import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/enums/noteActionEnums.dart';
import 'package:my_notes/widgets/addNotePagesAppBar.dart';

import '../Utils/ColorsUtility.dart';
import '../Utils/PaddingUtility.dart';
import '../controllers/note_controller.dart';
import '../enums/noteTypeEnums.dart';
import 'package:get/get.dart';

import '../widgets/imageDisplaySheetAppBar.dart';

class ImageEntrySheet extends StatefulWidget {
  const ImageEntrySheet({Key? key, required this.noteAction}) : super(key: key);

  final NoteAction noteAction;

  @override
  _ImageEntrySheetState createState() => _ImageEntrySheetState();
}

class _ImageEntrySheetState extends State<ImageEntrySheet> {

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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    noteController.disposeTextEditingControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("heha");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorsUtility.scaffoldBlackThemeBackgroundColor,
      appBar: AddNoteSheetsAppBar(
        noteTitleController: Get.find<NoteController>().noteTitleController,
        //note: noteController.currentNote,
        noteTypeEnum: NoteTypeEnum.imageNote, noteAction: widget.noteAction,
      ),
      body: Padding(
        padding: PaddingUtility.scaffoldBodyGeneralPadding,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 7 / 10,
            height: MediaQuery.of(context).size.height * 6 / 10,
            child: FittedBox(
              clipBehavior: Clip.hardEdge,
              fit: BoxFit.contain,
              child: CachedNetworkImage(
                imageUrl: noteController.currentNote.imagePath.toString(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
