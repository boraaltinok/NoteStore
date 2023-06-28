import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_notes/Models/Book.dart';
import 'package:my_notes/Screens/notesPage/notes_page.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/controllers/book_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/PaddingUtility.dart';
import '../../Utils/QuotesUtility.dart';
import 'BookCard.dart';

class BookList extends StatefulWidget {
  const BookList({Key? key}) : super(key: key);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  BookController bookController = Get.put(BookController());

  late QuotesUtility quotesUtility;
  late List randomQuote;

  @override
  void initState() {
    // TODO: implement initState
    quotesUtility = QuotesUtility();
    randomQuote = quotesUtility.selectRandomQuote();
    super.initState();
  }

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
            Expanded(
                flex: 10,
                child: bookController.bookList.isEmpty
                    ? Padding(
                        padding: PaddingUtility.scaffoldBodyGeneralPadding * 2,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                randomQuote[0],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.petitFormalScript(
                                    color: ColorsUtility.hintTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              Text(
                                "-${randomQuote[1]}",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.petitFormalScript(
                                    color: ColorsUtility.hintTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 4 / 5,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15),
                        itemCount: bookController.bookList.length,
                        itemBuilder: (ctx, i) {
                          return InkWell(
                            child: Container(
                              decoration: BoxDecoration(),
                              //color: Colors.red,
                              constraints: const BoxConstraints(
                                  minHeight: 80, maxHeight: 500),
                              child: BookCard(
                                  book: bookController.bookList[i],
                                  onDelete: () {
                                    bookController
                                        .deleteBook(bookController.bookList[i]);
                                  }),
                            ),
                            onTap: () {
                              print("ontap");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotesPage(
                                          bookController.bookList[i]!)));
                            },
                            onLongPress: () {
                              bookController.onBookLongPressed();
                            },
                          );
                        })),
          ],
        ),
      );
    });
  }
}
