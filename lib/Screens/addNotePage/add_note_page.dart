import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_notes/Screens/bookPage/books_page.dart';
import 'package:my_notes/Screens/notesPage/notes_page.dart';
import 'package:my_notes/enums/noteTypeEnums.dart';

import '../../Databases/NotesDatabase.dart';
import '../../Models/Book.dart';
import '../../Models/Note.dart';
import '../../controllers/note_controller.dart';
import 'package:get/get.dart';
class AddNotePage extends StatefulWidget {
  //final String? bookId;
  final Book? book;
  final String? scannedText;
  final Note? toBeEditedNote;
  final String? spokenText;

  AddNotePage(
      {Key? key,
      @required this.book,
      this.scannedText = "nullScannedText",
      this.spokenText = "nullSpokenText",
      this.toBeEditedNote})
      : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final formKey = GlobalKey<FormState>();
  late String _dropDownResult;
  late TextEditingController noteTitleEditingController;
  late TextEditingController notePageEditingController;
  late TextEditingController noteTextEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dropDownResult = 'alinti';
    noteTitleEditingController = TextEditingController();
    notePageEditingController = TextEditingController();
    noteTextEditingController = TextEditingController(
        text: widget.scannedText == "nullScannedText"
            ? (widget.spokenText == "nullSpokenText" ? "" : widget.spokenText)
            : widget.scannedText);
    if (widget.toBeEditedNote != null) {
      notePageEditingController = TextEditingController(
          text: widget.toBeEditedNote?.notePage == null ? "":widget.toBeEditedNote?.notePage.toString());
      noteTitleEditingController = TextEditingController(
          text: widget.toBeEditedNote?.noteTitle.toString());
      noteTextEditingController =
          TextEditingController(text: widget.toBeEditedNote?.noteText);
      _dropDownResult = widget.toBeEditedNote!.noteType;
    } else {
      noteTitleEditingController = TextEditingController();
      notePageEditingController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    ScrollController _scrollController =
        ScrollController(initialScrollOffset: 0);

    NoteController noteController = Get.put(NoteController());




    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.only(top: 15),
          //margin: EdgeInsets.fromLTRB(40, 40, 40, 80),
          decoration: const BoxDecoration(color: Color(0xffffffff)),
          child: Column(
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
                                      builder: (context) =>
                                          NotesPage(widget.book!)));
                            },
                            icon: const Icon(Icons.arrow_circle_left),
                            iconSize: 25,
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                        flex: 1,
                        child: Image(
                            image: AssetImage("assets/logo3.png")))
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Title',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              TextFormField(
                                controller: noteTitleEditingController,
                                /*validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please input title';
                                  }
                                  return null;
                                },*/
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(25)
                                ],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  hintText: "enter title(optional)",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Note',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Scrollbar(
                              controller: _scrollController,
                              thumbVisibility: true,
                              thickness: 10,
                              radius: Radius.circular(15),
                              child: TextFormField(
                                controller: noteTextEditingController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please input note';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(470)
                                ],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  hintText: "enter note",
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                  ),
                                ),
                                minLines: 10,
                                keyboardType: TextInputType.multiline,
                                maxLines: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Page Number',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              TextFormField(
                                controller: notePageEditingController,
                                /*validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please input page number';
                                  }
                                  return null;
                                },*/
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  hintText: "enter page number(optional)",
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: DropDownFormField(
                              titleText: 'Note Type',
                              hintText: 'Please choose one',
                              value: _dropDownResult,
                              onSaved: (value) {},
                              onChanged: (value) {
                                setState(() {
                                  _dropDownResult = value;
                                });
                              },
                              dataSource: const [
                                {
                                  "display": "Citation",
                                  "value": "alinti",
                                },
                                {
                                  "display": "Source",
                                  "value": "kaynakca",
                                },
                                /*{
                                  "display": "Özel Notum",
                                  "value": "özel_notum",
                                },*/
                                {
                                  "display": "Other",
                                  "value": "diger",
                                },
                              ],
                              textField: 'display',
                              valueField: 'value',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: FloatingActionButton.extended(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if (widget.toBeEditedNote == null) {
                                    const snackBar = SnackBar(
                                        content: Text(
                                            'Note Have been Successfully Added '));
                                    print("IMAGE PATH${noteController.imagePath}");

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    noteController.uploadNote(noteText: noteTextEditingController.text,
                                        noteTitle: noteTitleEditingController.text,notePage: notePageEditingController.text != "" ? int.parse(
                                          notePageEditingController.text) : null, imagePath: noteController.imagePath, noteTypeEnum: NoteTypeEnum.manuelNote);
                                    /*addNote(
                                        bookId: widget.bookId!,
                                        noteTitle: noteTitleEditingController.text,
                                        notePage: notePageEditingController.text != "" ? int.parse(
                                            notePageEditingController.text) : null,
                                        noteText: noteTextEditingController.text);*/

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotesPage(widget.book!)));
                                  } else if (widget.toBeEditedNote != null) {
                                    const snackBar = SnackBar(
                                        content: Text(
                                            'Note Have been Successfully Edited'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    Note editedNote = Note(
                                        bookId: widget.book!.bookId!,
                                        addedBy: widget.toBeEditedNote!.addedBy,
                                        noteType: _dropDownResult,
                                        noteText:
                                            noteTextEditingController.text,
                                        noteTitle:
                                            noteTitleEditingController.text,
                                        notePage: notePageEditingController.text != "" ? int.parse(
                                            notePageEditingController.text) : null,
                                        dateAdded:
                                            widget.toBeEditedNote!.dateAdded);
                                    /*updateNote(widget.toBeEditedNote!.noteId!,
                                        editedNote);*/
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotesPage(widget.book!)));
                                  }
                                }
                              },
                              label: widget.toBeEditedNote == null
                                  ? const Text(
                                      "ADD NOTE",
                                    )
                                  : const Text("EDIT NOTE"),
                              backgroundColor: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*Future<Note> addNote(
  {required int bookId, noteTitle , notePage , required String noteText}) async {
    Note newNote = Note(
        bookId: bookId,
        addedBy: 'manuel',
        noteTitle: noteTitle,
        notePage: notePage,
        noteText: noteText,
        noteType: _dropDownResult,
        dateAdded: DateTime.now());
    return NotesDatabase.instance.createNote(newNote);
  }*/

  /*Future updateNote(int noteId, Note note) async {
    Note updatedNote = Note(
        noteId: noteId,
        bookId: note.bookId,
        noteType: note.noteType,
        addedBy: note.addedBy,
        noteText: note.noteText,
        noteTitle: note.noteTitle,
        notePage: note.notePage,
        dateAdded: note.dateAdded);
    await NotesDatabase.instance.updateNote(updatedNote);
  }*/
}
