import 'package:flutter/cupertino.dart';
import 'package:my_notes/Databases/NotesDatabase.dart';
import 'package:sqflite/sqflite.dart';

import '../Models/Book.dart';
import '../Models/Note.dart';

class BookNotes extends StatefulWidget {
  const BookNotes({Key? key}) : super(key: key);

  @override
  _BookNotesState createState() => _BookNotesState();
}

class _BookNotesState extends State<BookNotes> {
  late List<Note> notes;
  late List<Book> books;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //addNote();
    //Note tmpNote =Note(bookId: 1, addedBy: 'speech', noteTitle: 'ceydognot3EDITED', notePage: 77, noteText: 'textceydogEDITED', dateAdded: DateTime.now());
    //updateNote(1, tmpNote);
    //refreshNotes();
    //Note newBook = Book(bookAuthor: "WALTER", bookName, dateAdded: )
    //print("deleting a node");
    deleteDatabase();


    //deleteBook(1);

    //deleteBook(1);
    //deleteNote(1);
    /*addBook();
    addBook();
    addBook();
    addBook();*/
    /*refreshBooks();
    refreshNotes();*/

    /*addNote(1);
    addNote(1);
    addNote(1);
    addNote(2);
    addNote(3);
    addNote(3);
    addNote(4);
    addNote(5);
    addBook();
    addBook();



    refreshBooks();
    refreshNotes();
    deleteBook(1);
    addBook();

    refreshBooks();
    refreshNotes();*/

    //addNote(3);
    /*refreshNotes();
    deleteNote(3);
    deleteNote(4);
    deleteNote(5);
    deleteNote(6);
    deleteNote(7);*/
    //deleteDatabase();






  }
  @override
  Widget build(BuildContext context) {

    return Container();
  }

  Future<Book> addBook() async {
    print("ADDING A BOOK");
    Book newBook = Book( bookAuthor: "WALT", bookName: "BOOK NAME1", dateAdded: DateTime.now());
    return NotesDatabase.instance.createBook(newBook);
  }
  Future refreshBooks() async {
    print("listing books:");
    books = await NotesDatabase.instance.readAllBooks();

    for(int i = 0; i< books.length; i++ ){
      print('BOOK ID: ${books[i].bookId}, BOOK NAME: ${books[i].bookName}, BOOK AUTHOR: ${books[i].bookAuthor}, DATE ADDED: ${books[i].dateAdded}');
    }
  }

  Future updateBook(int bookId, Book book) async{
    Book updateBook = Book(bookId: bookId, bookAuthor: book.bookAuthor, bookName: book.bookName, dateAdded: book.dateAdded );//Note(noteId: noteId,bookId: note.bookId, addedBy: note.addedBy, noteText: note.noteText, noteTitle: note.noteTitle, notePage: note.notePage, dateAdded: note.dateAdded);
    await NotesDatabase.instance.updateBook(updateBook);
  }

  Future deleteBook(int bookId) async{
    print('deleting the book with BOOK ID${bookId}');
    await NotesDatabase.instance.deleteBook(bookId);
  }

  Future<Note> addNote(int bookId) async {
    print('ADDING A NOTE TO BOOK WITH ID $bookId');
    Note newNote = Note(bookId: bookId, addedBy: 'speech', noteTitle: 'ceydognot3', noteType: 'alinti', notePage: 77, noteText: 'textceydog', dateAdded: DateTime.now());
    return NotesDatabase.instance.createNote(newNote);
  }

  Future refreshNotes() async{
    setState(() => isLoading = true);
    //NotesDatabase.instance.close();
    //NotesDatabase.instance.deleteDB();
    print("listing notes:");

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = true);

    for(int i = 0; i< notes.length; i++ ){
      print('NOTE ID ${notes[i].noteId}, BOOK ID ${notes[i].bookId}, NOTE TITLE${notes[i].noteTitle}, DATE ADDED ${notes[i].dateAdded}');

    }
  }
  Future updateNote(int noteId, Note note) async{
    Note updatedNote = Note(noteId: noteId,bookId: note.bookId,noteType: note.noteType, addedBy: note.addedBy, noteText: note.noteText, noteTitle: note.noteTitle, notePage: note.notePage, dateAdded: note.dateAdded);
    await NotesDatabase.instance.updateNote(updatedNote);
  }

  Future deleteNote(int noteId) async{
    await NotesDatabase.instance.deleteNote(noteId);
  }

  Future deleteDatabase() async{
    print("deleting the database");
    await NotesDatabase.instance.deleteDB();
  }
}
