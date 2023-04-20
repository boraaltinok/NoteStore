import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_notes/Databases/NotesDatabase.dart';
import 'package:my_notes/Models/Book.dart';
import 'package:my_notes/Screens/notesPage/notes_page.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/controllers/book_controller.dart';

import 'BookCard.dart';

class BookList extends StatefulWidget {
  final List<Book> books;

  const BookList(this.books, {Key? key}) : super(key: key);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  BookController bookController = Get.put(BookController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: ColorsUtility.transparentColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            /*Expanded(
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
                      "Your Books",
                      style: TextStyle(fontSize: 32, color: Color(0xff00386B)),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),*/
            Expanded(
                flex: 10,
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 4/5,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15
                    ),
                    itemCount: bookController.bookList.length,
                    itemBuilder: (ctx, i) {
                      return InkWell(
                        child: Container(
                          decoration: BoxDecoration(

                          ),
                          //color: Colors.red,
                          constraints: const BoxConstraints(
                              minHeight: 80, maxHeight: 500),
                          child: BookCard(
                              book: bookController.bookList[i],
                              onDelete: () {
                                bookController.deleteBook(
                                    bookController.bookList[i]);
                              }),
                        ),
                        onTap: () {
                          print("ontap");
                          Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NotesPage(bookController.bookList[i]!)));
                        },
                        onLongPress: (){
                          bookController.onBookLongPressed();
                        },
                      );
                    })
                ),
          ],
        ),
      );
    });
  }
}
