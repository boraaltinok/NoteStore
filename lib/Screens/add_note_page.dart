import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_notes/Screens/books_page.dart';
import 'package:my_notes/Screens/notes_page.dart';

import '../Databases/NotesDatabase.dart';
import '../Models/Book.dart';
import '../Models/Note.dart';

class AddNotePage extends StatefulWidget {
  final int? bookId;
  final String? scannedText;
  final Note? toBeEditedNote;
  final String? spokenText;

  AddNotePage(
      {Key? key,
      @required this.bookId,
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
                                          NotesPage(widget.bookId)));
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
                              const Text(
                                'Başlık',
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
                                  hintText: "başlık girin(opsiyonel)",
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
                              'Not',
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
                                    return 'Not girin';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(470)
                                ],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  hintText: "Not girin",
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
                                'Sayfa No',
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
                                  hintText: "Sayfa no girin(opsiyonel)",
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
                              titleText: 'Not Tipi',
                              hintText: 'Birini seçin',
                              value: _dropDownResult,
                              onSaved: (value) {},
                              onChanged: (value) {
                                setState(() {
                                  _dropDownResult = value;
                                });
                              },
                              dataSource: const [
                                {
                                  "display": "Alıntı",
                                  "value": "alinti",
                                },
                                {
                                  "display": "Kaynak",
                                  "value": "kaynakca",
                                },
                                /*{
                                  "display": "Özel Notum",
                                  "value": "özel_notum",
                                },*/
                                {
                                  "display": "Diğer",
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
                                            'Not Başarılı Şekilde Eklendi'));

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    addNote(
                                        bookId: widget.bookId!,
                                        noteTitle: noteTitleEditingController.text,
                                        notePage: notePageEditingController.text != "" ? int.parse(
                                            notePageEditingController.text) : null,
                                        noteText: noteTextEditingController.text);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotesPage(widget.bookId)));
                                  } else if (widget.toBeEditedNote != null) {
                                    const snackBar = SnackBar(
                                        content: Text(
                                            'Not Başarılı Şekilde Editlendi'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    print('page : ${notePageEditingController.text}');
                                    Note editedNote = Note(
                                        bookId: widget.bookId!,
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
                                    updateNote(widget.toBeEditedNote!.noteId!,
                                        editedNote);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotesPage(widget.bookId)));
                                  }
                                }
                              },
                              label: widget.toBeEditedNote == null
                                  ? const Text(
                                      "NOT EKlE",
                                    )
                                  : const Text("NOT EDİTLE"),
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

  Future<Note> addNote(
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
  }

  Future updateNote(int noteId, Note note) async {
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
  }
}
