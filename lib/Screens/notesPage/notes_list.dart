import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_notes/Databases/NotesDatabase.dart';
import 'package:my_notes/Screens/addNotePage/add_note_page.dart';
import 'package:my_notes/Screens/notesPage/note_card.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/controllers/speech_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../Models/Book.dart';
import '../../Models/Note.dart';
import '../../controllers/note_controller.dart';
import 'package:get/get.dart';

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

  NoteController noteController = Get.put(NoteController());
  SpeechController speechController = Get.put(SpeechController());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //isLoading = true;
    isLoading = false;
    noteController.updateBookId(widget.book.bookId!);
    getSelectedBook();
    listedNoteType = 'alinti';
    speechController.initRecorder();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    speechController.recorder.closeRecorder();
    speechController.audioPlayer.dispose();
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
                    /*Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 3),
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xffffffff)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                '${widget.book.bookName!}',
                                style: const TextStyle(fontSize: 32, color: Color(0xff00386B)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),*/
                    /*Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ToggleSwitch(
                            minWidth: 90.0,
                            initialLabelIndex: typePosition,
                            cornerRadius: 20.0,
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.grey,
                            inactiveFgColor: Color(0xff454545),
                            totalSwitches: 3,
                            labels: ['Citation', 'Source', 'Other'],
                            //icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
                            activeBgColors: const [
                              [Color(0xff00386B)],
                              [Color(0xff00386B)],
                              [Color(0xff00386B)],
                              //[Color(0xfffaf0e6)]
                            ],
                            onToggle: (index) {
                              if (index == 0) {
                                setState(() {
                                  listedNoteType = 'alinti';
                                  typePosition = 0;
                                });
                              } else if (index == 1) {
                                setState(() {
                                  listedNoteType = 'kaynakca';
                                  typePosition = 1;
                                });
                              }  else if (index == 2) {
                                setState(() {
                                  listedNoteType = 'diger';
                                  typePosition = 2;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),*/
                    Expanded(
                        child: MasonryGridView.count(
                          padding: EdgeInsets.only(top: 0),
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemCount: noteController.noteList.length,
                      itemBuilder: (context, i) {
                        print(noteController.noteList[i].toJson());
                        print("noteType");

                        print(noteController.noteList[i].noteType);
                          return GestureDetector(
                            onTap: () async {
                              /*await speechController.audioPlayer.play(UrlSource(
                                  "${noteController.noteList[i].speechPath}"
                              ));*/
                            },
                            child: NoteCard(
                              note: noteController.noteList[i],
                              index: i,
                              onDelete: () => onDeleteNote(widget.notes[i], i),
                              onEdit: () {
                                /*since all the notes in this page belong to same book I can find the
                        * book id by widget.notes[any index].bookId*/
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
                          );

                      },
                    ))
                  ],
                ),
              );
          }
        );
  }

  Future getSelectedBook() async {
    /*selectedBook = (await NotesDatabase.instance.readBook(widget.bookId))!;

    setState(() {
      isLoading = false;
    });*/
  }

  void onDeleteNote(Note note, int index) {
    //NotesDatabase.instance.deleteNote(widget.notes[index].noteId!);
    setState(() {
      widget.notes.remove(note);
    });
  }
}
