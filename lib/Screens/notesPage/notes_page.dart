import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_notes/Screens/addNotePage/add_note_page.dart';
import 'package:my_notes/Screens/addNotePage/add_speech_page.dart';
import 'package:my_notes/Screens/addNotePage/scan_text_page.dart';
import 'package:my_notes/Screens/addNotePage/speech_to_text_page.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/controllers/note_controller.dart';

import '../../Databases/NotesDatabase.dart';
import '../../Models/Book.dart';
import '../../Models/Note.dart';
import '../../Utils/PaddingUtility.dart';
import '../bookPage/books_page.dart';
import 'notes_list.dart';
import 'package:get/get.dart';

class NotesPage extends StatefulWidget {
  final Book book;

  const NotesPage(this.book, {Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late bool isLoading;
  late List<Note> notes;

  //NoteController noteController = Get.put(NoteController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //isLoading = true;
    isLoading = false;

    //refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Future.value(true),
        child: Scaffold(
          appBar: buildAppBar(),
          body: Padding(
            padding: PaddingUtility.scaffoldGeneralPaddingOnlyTRL,
            child: Container(
              padding: PaddingUtility.paddingTop10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /*Expanded(
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
                                            builder: (context) =>
                                                const BooksPage()));
                                  },
                                  icon: const Icon(Icons.arrow_circle_left),
                                  iconSize: 25,
                                ),
                              ],
                            ),
                          ),
                          const Expanded(
                              flex: 3,
                              child: Image(image: AssetImage("assets/logo3.png")))
                        ],
                      ),
                    ),*/
                  Expanded(
                    flex: 10,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            //height: 650,
                            //decoration: BoxDecoration(color: Colors.black),
                            child: isLoading == true
                                ? const Center(child: Text('NOTES ARE LOADING'))
                                : NotesList(
                                    //notes: notes,
                                    notes: [],
                                    book: widget.book!,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Expanded(flex: 1, child: Container())
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
                                  book: widget.book,
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
                            builder: (context) => ScanTextPage(widget.book)));
                  },
                  child: const Icon(Icons.insert_photo),
                  label: "Record by Photo"),
              SpeedDialChild(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SpeechToTextScreen(book: widget.book)));
                  },
                  child: const Icon(Icons.mic),
                  label: "Record Text by Voice"),
              SpeedDialChild(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddSpeechPage()));
                  },
                  child: const Icon(Icons.mic),
                  label: "Record Voice")
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomNavigationBar(items: const [
            BottomNavigationBarItem(icon: Icon(null), label: ''),
            BottomNavigationBarItem(icon: Icon(null), label: '')
          ],elevation: 10,backgroundColor: ColorsUtility.appBarBackgroundColor,),
        ));
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        widget.book.bookName.toString(),
        style: TextStyle(color: ColorsUtility.appBarTitleColor),
      ),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: ColorsUtility.appBarIconColor,
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }

/*Future refreshNotes() async {
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
  }*/
}
