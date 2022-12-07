import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_notes/Screens/add_note_page.dart';
import 'package:my_notes/Screens/scan_text_page.dart';
import 'package:my_notes/Screens/speech_to_text_page.dart';

import '../Databases/NotesDatabase.dart';
import '../Models/Note.dart';
import 'books_page.dart';
import 'notes_list.dart';

class NotesPage extends StatefulWidget {
  final int? bookId;

  const NotesPage(this.bookId, {Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late bool isLoading;
  late List<Note> notes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(color: Color(0xffffffff)),
            padding: EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const BooksPage()));
                              },
                              icon: const Icon(Icons.arrow_circle_left),
                              iconSize: 25,
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                          flex: 3,
                          child: Image(
                              image: AssetImage("assets/logo3.png")))
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          height: 650,
                          decoration: BoxDecoration(color: Colors.black),
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: isLoading == true
                              ? const Center(child: Text('NOTES ARE LOADING'))
                              : NotesList(
                                  notes: notes,
                                  bookId: widget.bookId!,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 1, child: Container())
                /*Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 4),
                      borderRadius: BorderRadius.circular(50)),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              //builder: (context) => AddNotePage(widget.bookId)));
                              builder: (context) =>
                                  AddNoteByPage(widget.bookId)));
                    },
                  ),
                ),*/
              ],
            ),
          ),
          floatingActionButton: SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            children: [
              SpeedDialChild(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNotePage(
                                  bookId: widget.bookId,
                                )));
                  },
                  child: const Icon(
                    (Icons.note),
                  ),
                  label: "Manual Entry"),
              SpeedDialChild(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScanTextPage(widget.bookId)));
                  },
                  child: const Icon(Icons.insert_photo),
                  label: "Record by Photo"),
              SpeedDialChild(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SpeechToTextScreen(bookId: widget.bookId)));
                  },
                  child: const Icon(Icons.mic),
                  label: "Record Voice")
            ],
          )),
    );
  }

  Future refreshNotes() async {
    //NotesDatabase.instance.close();
    //NotesDatabase.instance.deleteDB();
    print("listing notes:");

    notes = await NotesDatabase.instance.readBooksNotes(widget.bookId);

    for (int i = 0; i < notes.length; i++) {
      print(
          'NOTE ID ${notes[i].noteId}, BOOK ID ${notes[i].bookId}, NOTE TITLE${notes[i].noteTitle}, DATE ADDED ${notes[i].dateAdded}');
    }
    setState(() {
      isLoading = false;
    });
  }
}
