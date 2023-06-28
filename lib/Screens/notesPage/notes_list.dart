import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_notes/Databases/NotesDatabase.dart';
import 'package:my_notes/NoteSheets/image_entry_sheet.dart';
import 'package:my_notes/NoteSheets/manuel_entry_sheet.dart';
import 'package:my_notes/Screens/addNotePage/add_note_page.dart';
import 'package:my_notes/Screens/notesPage/image_card.dart';
import 'package:my_notes/Screens/notesPage/manuel_card.dart';
import 'package:my_notes/Screens/notesPage/note_card.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/PaddingUtility.dart';
import 'package:my_notes/Utils/QuotesUtility.dart';
import 'package:my_notes/Utils/TextStyleUtility.dart';
import 'package:my_notes/controllers/speech_controller.dart';
import 'package:my_notes/enums/noteActionEnums.dart';
import 'package:my_notes/enums/noteTypeEnums.dart';
import 'package:my_notes/widgets/imageDisplaySheetAppBar.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../Models/Book.dart';
import '../../Models/Note.dart';
import '../../controllers/note_controller.dart';
import 'package:get/get.dart';

import '../../widgets/imageDisplaySheetAppBar.dart';

class NotesList extends StatefulWidget {
  final List<Note> notes;
  final Book book;

  const NotesList({required this.notes, required this.book, Key? key})
      : super(key: key);

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  late String listedNoteType;
  int typePosition = 0;

  //late Book selectedBook;
  late bool isLoading;

  late NoteController noteController;
  late SpeechController speechController;
  late QuotesUtility quotesUtility;
  late List randomQuote;

  @override
  void initState() {
    // TODO: implement initState
    quotesUtility = QuotesUtility();
    randomQuote = quotesUtility.selectRandomQuote();
    super.initState();
    //isLoading = true;
    noteController = Get.put(NoteController());
    speechController = Get.put(SpeechController());
    isLoading = false;
    noteController.updateBookId(widget.book.bookId!);
    getSelectedBook();
    listedNoteType = 'alinti';
    //speechController.initRecorder();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //speechController.recorder.closeRecorder();
    //speechController.audioPlayer.dispose();
    print("noteslist dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(child: Text('LOADING'))
        : Obx(() {
            return Container(
              decoration: BoxDecoration(
                  color: ColorsUtility.transparentColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Expanded(
                      child: noteController.noteList.isEmpty  ? Padding(
                        padding: PaddingUtility.scaffoldBodyGeneralPadding * 2,
                        child: Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(randomQuote[0],textAlign: TextAlign.center, style: GoogleFonts.petitFormalScript(color: ColorsUtility.hintTextColor, fontWeight: FontWeight.bold, fontSize: 18),),
                            Text("-${randomQuote[1]}",textAlign: TextAlign.center, style: GoogleFonts.petitFormalScript(color: ColorsUtility.hintTextColor, fontWeight: FontWeight.bold, fontSize: 14),),

                          ],
                        ),),
                      ) :MasonryGridView.count(
                    padding: const EdgeInsets.only(top: 0),
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemCount: noteController.noteList.length,
                    itemBuilder: (context, i) {
                      print(noteController.noteList[i].noteType);
                      if (noteController.noteList[i].noteType == "imageNote") {
                        return NoteTypeEnum.imageNote
                            .returnGestureDetectorWithSheet(
                                i: i,
                                context: context,
                                noteAction: NoteAction.noteEdit);
                      } else if (noteController.noteList[i].noteType ==
                          "speechNote") {
                        /*return GestureDetector(
                          onTap: () {},
                          child: NoteCard(
                            note: noteController.noteList[i],
                            index: i,
                            onDelete: () => onDeleteNote(widget.notes[i], i),
                            onEdit: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddNotePage(
                                            book: widget.book,
                                            toBeEditedNote: widget.notes[i],
                                          )));
                            },
                            onView: () {},
                          ),
                        );*/
                        return NoteTypeEnum.speechNote
                            .returnGestureDetectorWithSheet(
                                i: i,
                                context: context,
                                noteAction: NoteAction.noteEdit);
                      } else if (noteController.noteList[i].noteType ==
                          "manuelNote") {
                        return NoteTypeEnum.manuelNote
                            .returnGestureDetectorWithSheet(
                                i: i,
                                context: context,
                                noteAction: NoteAction.noteEdit);
                      } else if(noteController.noteList[i].noteType ==
                          "imageToTextNote"){
                        return NoteTypeEnum.imageToTextNote
                            .returnGestureDetectorWithSheet(
                            i: i,
                            context: context,
                            noteAction: NoteAction.noteEdit);
                      }else if(noteController.noteList[i].noteType ==
                          "speechToTextNote"){
                        return NoteTypeEnum.speechToTextNote
                            .returnGestureDetectorWithSheet(
                            i: i,
                            context: context,
                            noteAction: NoteAction.noteEdit);
                      }
                      else {
                        return Text("NOTE NOT FOUND");
                      }
                      /*return noteController.noteList[i].noteType == "imageNote"
                          ? GestureDetector(
                              onTap: () {
                                noteController.initTextEditingControllers();
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
                                        child:Scaffold(
                                          resizeToAvoidBottomInset: false,
                                          backgroundColor: ColorsUtility
                                              .scaffoldBlackThemeBackgroundColor,
                                          appBar: ImageDisplaySheetAppBar(
                                            noteTitleController:
                                                Get.find<NoteController>()
                                                    .noteTitleController,
                                            note: noteController.noteList[i],
                                            noteTypeEnum:
                                                NoteTypeEnum.imageNote,
                                          ),
                                          body: Padding(
                                            padding: PaddingUtility
                                                .scaffoldBodyGeneralPadding,
                                            child: Center(
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    7 /
                                                    10,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    6 /
                                                    10,
                                                child: FittedBox(
                                                  clipBehavior: Clip.hardEdge,
                                                  fit: BoxFit.contain,
                                                  child: CachedNetworkImage(
                                                    imageUrl: noteController
                                                        .noteList[i].imagePath
                                                        .toString(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: ImageCard(
                                note: noteController.noteList[i],
                              ))
                          : GestureDetector(
                              onTap: () {},
                              child: NoteCard(
                                note: noteController.noteList[i],
                                index: i,
                                onDelete: () =>
                                    onDeleteNote(widget.notes[i], i),
                                onEdit: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddNotePage(
                                                book: widget.book,
                                                toBeEditedNote: widget.notes[i],
                                              )));
                                },
                                onView: () {},
                              ),
                            );*/
                    },
                  ))
                ],
              ),
            );
          });
  }

  Future getSelectedBook() async {
    /*selectedBook = (await NotesDatabase.instance.readBook(widget.bookId))!;

    setState(() {
      isLoading = false;
    });*/
  }

  void onDeleteNote(Note note, int index) {
    //NotesDatabase.instance.deleteNote(widget.notes[index].noteId!);
    /*setState(() {
      widget.notes.remove(note);
    });*/
  }
}
