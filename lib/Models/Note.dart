

import 'package:uuid/uuid.dart';
enum AddedBy {
  speech, photo, text
}

const String tableNotes = 'notes';

class NoteFields {

  static final List<String> values = [
    noteId, bookId, noteText, noteTitle, notePage, noteType, addedBy, dateAdded
  ];
 static const String noteId = 'note_id';
 static const String bookId = 'book_id';
 static const String noteText = 'note_text';
 static const String noteTitle = 'note_title';
 static const String notePage = 'note_page';
 static const String noteType = 'note_type';
 static const String addedBy = 'added_by';
 static const String dateAdded = 'date_added';


}
class Note {
  final int? noteId;
  final int bookId;
  String noteText;
  String? noteTitle;
  int? notePage;
  final String noteType;
  final String addedBy;
  final DateTime dateAdded;

  Note({this.noteId, required this.bookId, required this.addedBy, required this.noteType, required this.noteText, this.noteTitle, this.notePage,
    required this.dateAdded
  });

  Note copy({
  int? noteId,
  int? bookId,
  String? noteText,
  String? noteTitle,
  int? notePage,
    String? noteType,
    String? addedBy,
  DateTime? dateAdded
}) =>
      Note(
          noteId: noteId ?? this.noteId,
          bookId: bookId ?? this.bookId,
          noteText: noteText ?? this.noteText,
          noteTitle: noteTitle ?? this.noteTitle,
          notePage: notePage ?? this.notePage,
          noteType: noteType ?? this.noteType,
          addedBy: addedBy ?? this.addedBy,
          dateAdded: dateAdded ?? this.dateAdded
          );

  Map<String, Object?> toJson() => {
    NoteFields.noteId: noteId,
    NoteFields.bookId: bookId,
    NoteFields.noteText: noteText,
    NoteFields.noteTitle: noteTitle,
    NoteFields.notePage: notePage,
    NoteFields.noteType: noteType,
    NoteFields.addedBy: addedBy,
    NoteFields.dateAdded: dateAdded.toIso8601String(),
  };

  static Note fromJson(Map<String, Object?> json) => Note(
    noteId: json[NoteFields.noteId] as int,
    bookId: json[NoteFields.bookId] as int,
    noteText: json[NoteFields.noteText] as String,
    noteTitle: json[NoteFields.noteTitle] as String,
    notePage: json[NoteFields.notePage] as int,
    noteType: json[NoteFields.noteType] as String,
    addedBy: json[NoteFields.noteText] as String,
    dateAdded: DateTime.parse(json[NoteFields.dateAdded] as String),
  );



}