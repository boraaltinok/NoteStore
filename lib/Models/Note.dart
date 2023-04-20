import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';


const String tableNotes = 'notes';

class NoteFields {

  static final List<String> values = [
    noteId, bookId, noteText, noteTitle, notePage, noteType, addedBy, dateAdded, speechPath, imagePath, speechDuration
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
  static const String speechDuration = 'speech_duration';

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
  final int? speechDuration;

  Note(
      {this.noteId, this.imagePath = '', this.speechPath= '', required this.bookId, required this.addedBy, required this.noteType, required this.noteText, this.noteTitle, this.notePage,
        required this.dateAdded, this.speechDuration = 0
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
    String? imagePath,
    int? speechDuration
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
          imagePath: imagePath ?? this.imagePath,
          speechDuration: speechDuration ?? this.speechDuration
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
        NoteFields.imagePath: imagePath,
        NoteFields.speechDuration: speechDuration
      };

  static Note fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Note(bookId: snapshot[NoteFields.bookId],
        noteId: snapshot[NoteFields.noteId],
        addedBy: snapshot[NoteFields.addedBy],
        noteType: snapshot[NoteFields.noteType],
        noteTitle: snapshot[NoteFields.noteTitle],
        noteText: snapshot[NoteFields.noteText],
        dateAdded: DateTime.parse(snapshot[NoteFields.dateAdded]),
        speechPath: snapshot[NoteFields.speechPath],
        imagePath: snapshot[NoteFields.imagePath],
        speechDuration: snapshot[NoteFields.speechDuration]);
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
        imagePath: json[NoteFields.imagePath] as String,
        speechDuration: json[NoteFields.speechDuration] as int
      );


}