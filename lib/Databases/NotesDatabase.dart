import 'package:my_notes/Models/Book.dart';
import 'package:my_notes/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_notes/Models/Note.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    //print("DATABASE PATH = $dbPath" );
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';
    const foreignKey = 'FOREIGN KEY(book_id) REFERENCES books(book_id)';

    await db.execute('''
    CREATE TABLE $tableBooks (
    ${BookFields.bookId} $textType,
    ${BookFields.bookName} $textType,
    ${BookFields.bookAuthor} $textType,
    ${BookFields.dateAdded} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableNotes (
    ${NoteFields.noteId} $idType,
    ${NoteFields.bookId} $integerType,
    ${NoteFields.noteText} $textType,
    ${NoteFields.noteTitle} TEXT,
    ${NoteFields.notePage} INTEGER,
    ${NoteFields.noteType} $textType,
    ${NoteFields.addedBy} $textType,
    ${NoteFields.dateAdded} $textType,
    $foreignKey,
    CONSTRAINT fk_bookId
      FOREIGN KEY(${NoteFields.bookId})
      REFERENCES books(book_id)
      ON DELETE CASCADE
    )
    ''');
  }

  Future<void> deleteDB() async {
    try {
      final dbPath = await getDatabasesPath();
      print("DATABASE PATH = $dbPath");
      final path = join(dbPath, 'notes.db');
      print('deleting db');
      deleteDatabase(path);
    } catch (e) {
      print(e.toString());
    }

    print('db is deleted');
  }

  Future<Book> createBook(Book book) async {
    final db = await instance.database;

    print("ABOUT TO CREATE A NOTE = ${book.toJson()}");

    final bookId = await db.insert(tableBooks, book.toJson());
    return book.copy(bookId: bookId.toString());
  }

  Future<Book?> readBook(int bookId) async {
    final db = await instance.database;

    final maps = await db.query(
      tableBooks,
      columns: BookFields.values,
      where: '${BookFields.bookId} = ?',
      whereArgs: [bookId],
    );

    if (maps.isNotEmpty) {
      return Book.fromJson(maps.first);
    } else {
      return Book(bookId: "", dateAdded: DateTime.now(), userId: authController.user.uid);
      //return null;
      //throw Exception('BOOK WITH ID $bookId not found');
    }
  }

  Future<List<Book>> readAllBooks() async {
    final db = await instance.database;
    const orderBy = '${BookFields.dateAdded} DESC'; // OR ASC
    final result = await db.query(tableBooks, orderBy: orderBy);

    return result.map((json) => Book.fromJson(json)).toList();
  }

  Future<int> updateBook(Book book) async {
    final db = await instance.database;

    return db.update(tableBooks, book.toJson(),
        where: '${BookFields.bookId} = ?', whereArgs: [book.bookId]);
  }

  Future<int> deleteBook(int bookId) async {
    final db = await instance.database;
    db.execute("PRAGMA foreign_keys = ON");
    return await db.delete(
      tableBooks,
      where: '${BookFields.bookId} = ?',
      whereArgs: [bookId],
    );
  }

  /*Future<Note> createNote(Note note) async {
    final db = await instance.database;
    //TODO ADD THE CHECK IF BOOK ID IS VALID
    //Book? returnedBook = await readBook(note.bookId); //if bookId returns -1 then book does not exist
    //print("DOES BOOK WITH ID ${note.bookId} EXISTS? = ${book.bookId != -1}");
    /*if(returnedBook?.bookId == -1){
      print("NOTE TO UNEXISTING BOOK ADDED");
    }*/
    //if(returnedBook.bookId != -1){
    final noteId = await db.insert(tableNotes, note.toJson());
    return note.copy(noteId: noteId);
    /*}
    else{
      return note.copy(noteId: -1);
    }*/
  }*/

  Future<Note> readNote(int noteId) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      where: '${NoteFields.noteId} = ?',
      whereArgs: [noteId],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $noteId not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    const orderBy = '${NoteFields.dateAdded} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> readBooksNotes(bookId) async {
    final db = await instance.database;
    const orderBy = '${NoteFields.dateAdded} DESC';
    final result = await db.query(tableNotes,
        where: '${NoteFields.bookId} = ?',
        whereArgs: [bookId],
        orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>?> readBooksNotesWithSelectedType(bookId, String noteType ) async {
    if(noteType != 'alinti' || noteType != 'kaynakca' || noteType !='özel_notum' || noteType != 'diger'){
      print("this noteType does not exist so you can not add it to database");
      return null;
    }
    final db = await instance.database;
    const orderBy = '${NoteFields.dateAdded} DESC';
    final result = await db.query(tableNotes,
        where: '${NoteFields.bookId} = ? and ${NoteFields.noteType} = ?',
        whereArgs: [bookId, noteType],
        orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;

    return db.update(tableNotes, note.toJson(),
        where: '${NoteFields.noteId} = ?', whereArgs: [note.noteId]);
  }

  Future<int> deleteNote(int noteId) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.noteId} = ?',
      whereArgs: [noteId],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
