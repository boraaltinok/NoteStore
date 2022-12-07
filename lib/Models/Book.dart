

import 'package:uuid/uuid.dart';


const String tableBooks = 'books';

class BookFields {

  static final List<String> values = [
    bookId, bookName, bookAuthor, dateAdded
  ];
  static const String bookId = 'book_id';
  static const String bookName = 'book_name';
  static const String bookAuthor = 'book_author';
  static const String dateAdded = 'date_added';


}

class Book {
  final int? bookId;
  final String? bookName;
  final String? bookAuthor;
  DateTime dateAdded;

  Book({this.bookId , this.bookName='My Default Book Name', this.bookAuthor='My Default Book Author', required this.dateAdded});

  Book copy({
    int? bookId,
    String? bookName,
    String? bookAuthor,
    DateTime? dateAdded,
  }) =>
      Book(
          bookId: bookId ?? this.bookId,
          bookName: bookName ?? this.bookName,
          bookAuthor: bookAuthor ?? this.bookAuthor,
          dateAdded: dateAdded ?? this.dateAdded,
      );

  Map<String, Object?> toJson() => {
    BookFields.bookId: bookId,
    BookFields.bookName: bookName,
    BookFields.bookAuthor: bookAuthor,
    BookFields.dateAdded: dateAdded.toIso8601String(),
  };

  static Book fromJson(Map<String, Object?> json) => Book(
    bookId: json[BookFields.bookId] as int,
    bookName: json[BookFields.bookName] as String,
    bookAuthor: json[BookFields.bookAuthor] as String,
    dateAdded: DateTime.parse(json[BookFields.dateAdded] as String),
  );

  static Book fromJsonFromIsbn(Map<String, Object?> json) => Book(
    bookName: json["title"] as String,
    bookAuthor: json["authors"] as String,
    dateAdded: DateTime.parse(json[BookFields.dateAdded] as String),
  );

}
