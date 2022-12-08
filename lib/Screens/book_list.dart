import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/Databases/NotesDatabase.dart';
import 'package:my_notes/Models/Book.dart';
import 'package:my_notes/Screens/notes_page.dart';

import 'BookCard.dart';

class BookList extends StatefulWidget {
  final List<Book> books;

  const BookList(this.books, {Key? key}) : super(key: key);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 3),
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "KİTAPLARIM",
                      style: TextStyle(fontSize: 32, color: Color(0xff00386B)),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
           Expanded(
             flex: 10,
             child: Container(
                  //height: 400,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 5),
                      itemCount: widget.books.length,
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) {
                        return GestureDetector(
                          child: Container(
                            constraints: BoxConstraints(minHeight: 80, maxHeight: 500),
                            child: BookCard(
                              book: widget.books[i],
                              onDelete: () => onDeleteBook(widget.books[i]),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NotesPage(widget.books[i].bookId)));
                          },
                        );
                      }),
                ),
           ),

            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  void onDeleteBook(Book book) {
    NotesDatabase.instance.deleteBook(book.bookId!);
    setState(() {
      widget.books.remove(book);
    });
  }
}
