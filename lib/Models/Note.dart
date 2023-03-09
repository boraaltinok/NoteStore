import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';


const String tableNotes = 'notes';

class NoteFields {

  static final List<String> values = [
    noteId, bookId, noteText, noteTitle, notePage, noteType, addedBy, dateAdded, speechPath, imagePath
  ];
  static const String noteId = 'note_id';
  static const String bookId = 'book_id';
  static const String noteText = 'note_text';
  static const String noteTitle = 'note_title';
  static const String notePage = 'note_page';
  static const String noteType = 'note_type';
  static const String addedBy = 'added_by';
  static const String dateAdded = 'date_added';
  static const String speechPath = 'speech_path';
  static const String imagePath = 'image_path';


}

class Note {
  final String? noteId;
  final String bookId;
  String noteText;
  String? noteTitle;
  int? notePage;
  final String noteType;
  final String addedBy;
  final DateTime dateAdded;
  final String? speechPath;
  final String? imagePath;

  Note(
      {this.noteId, this.imagePath = '', this.speechPath= '', required this.bookId, required this.addedBy, required this.noteType, required this.noteText, this.noteTitle, this.notePage,
        required this.dateAdded
      });

  Note copy({
    String? noteId,
    String? bookId,
    String? noteText,
    String? noteTitle,
    int? notePage,
    String? noteType,
    String? addedBy,
    DateTime? dateAdded,
    String? speechPath,
    String? imagePath
  }) =>
      Note(
          noteId: noteId ?? this.noteId,
          bookId: bookId ?? this.bookId,
          noteText: noteText ?? this.noteText,
          noteTitle: noteTitle ?? this.noteTitle,
          notePage: notePage ?? this.notePage,
          noteType: noteType ?? this.noteType,
          addedBy: addedBy ?? this.addedBy,
          dateAdded: dateAdded ?? this.dateAdded,
          speechPath: speechPath ?? this.speechPath,
          imagePath: imagePath ?? this.imagePath
      );

  Map<String, Object?> toJson() =>
      {
        NoteFields.noteId: noteId,
        NoteFields.bookId: bookId,
        NoteFields.noteText: noteText,
        NoteFields.noteTitle: noteTitle,
        NoteFields.notePage: notePage,
        NoteFields.noteType: noteType,
        NoteFields.addedBy: addedBy,
        NoteFields.dateAdded: dateAdded.toIso8601String(),
        NoteFields.speechPath: speechPath,
        NoteFields.imagePath: imagePath
      };

  static Note fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Note(bookId: snapshot[NoteFields.bookId],
        addedBy: snapshot[NoteFields.addedBy],
        noteType: snapshot[NoteFields.noteType],
        noteText: snapshot[NoteFields.noteText],
        dateAdded: DateTime.parse(snapshot[NoteFields.dateAdded]),
        speechPath: snapshot[NoteFields.speechPath],
        imagePath: snapshot[NoteFields.imagePath]);
  }

  static Note fromJson(Map<String, Object?> json) =>
      Note(
        noteId: json[NoteFields.noteId] as String,
        bookId: json[NoteFields.bookId] as String,
        noteText: json[NoteFields.noteText] as String,
        noteTitle: json[NoteFields.noteTitle] as String,
        notePage: json[NoteFields.notePage] as int,
        noteType: json[NoteFields.noteType] as String,
        addedBy: json[NoteFields.noteText] as String,
        dateAdded: DateTime.parse(json[NoteFields.dateAdded] as String),
        speechPath: json[NoteFields.speechPath] as String,
        imagePath: json[NoteFields.imagePath] as String
      );


}