import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_notes/constants.dart';
import 'package:uuid/uuid.dart';

const String tableBooks = 'books';

class BookFields {
  static final List<String> values = [
    bookId,
    bookName,
    bookAuthor,
    dateAdded,
    userId,
    bookCover
  ];
  static const String bookId = 'book_id';
  static const String bookName = 'book_name';
  static const String bookAuthor = 'book_author';
  static const String dateAdded = 'date_added';
  static const String userId = 'user_id';
  static const String bookCover = 'book_cover';
}

class Book {
  final String? bookId;
  final String? bookName;
  final String? bookAuthor;
  DateTime dateAdded;
  final String? userId;
  final String? bookCover;

  Book(
      {this.bookId,
      this.bookName = 'My Default Book Name',
      this.bookAuthor = 'My Default Book Author',
      this.bookCover = "",
      required this.userId,
      required this.dateAdded});

  Book copy(
          {String? bookId,
          String? bookName,
          String? bookAuthor,
          DateTime? dateAdded,
          String? userId,
          String? bookCover}) =>
      Book(
          bookId: bookId ?? this.bookId,
          bookName: bookName ?? this.bookName,
          bookAuthor: bookAuthor ?? this.bookAuthor,
          dateAdded: dateAdded ?? this.dateAdded,
          userId: userId ?? this.userId,
          bookCover: bookCover ?? this.bookCover);

  Map<String, Object?> toJson() => {
        BookFields.bookId: bookId,
        BookFields.bookName: bookName,
        BookFields.bookAuthor: bookAuthor,
        BookFields.dateAdded: dateAdded.toIso8601String(),
        BookFields.userId: userId,
        BookFields.bookCover: bookCover
      };

  static Book fromJson(Map<String, Object?> json) => Book(
      bookId: json[BookFields.bookId] as String,
      bookName: json[BookFields.bookName] as String,
      bookAuthor: json[BookFields.bookAuthor] as String,
      dateAdded: DateTime.parse(json[BookFields.dateAdded] as String),
      userId: json[BookFields.userId] as String,
      bookCover: json[BookFields.bookCover] as String);

  static Book fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Book(
        bookId: snapshot[BookFields.bookId] as String,
        bookName: snapshot[BookFields.bookName] as String,
        bookAuthor: snapshot[BookFields.bookAuthor] as String,
        dateAdded: DateTime.parse(snapshot[BookFields.dateAdded] as String),
        userId: snapshot[BookFields.userId],
        bookCover: snapshot[BookFields.bookCover]);
  }

  static Book fromJsonFromIsbn(Map<String, Object?> json) => Book(
      bookName: json["title"] as String,
      bookAuthor: json["authors"] as String,
      dateAdded: DateTime.parse(json[BookFields.dateAdded] as String),
      bookCover: json["image"] as String,
      userId: authController.user.uid);
}
