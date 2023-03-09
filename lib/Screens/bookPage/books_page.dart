import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_notes/Screens/bookPage/book_list.dart';
import 'package:my_notes/Screens/addBookPage/scan_book_page.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/PaddingUtility.dart';

import '../../Databases/NotesDatabase.dart';
import '../../Models/Book.dart';
import '../addBookPage/add_book_page.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({Key? key}) : super(key: key);

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  late List<Book> books;
  late bool isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    refreshBooks();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: buildAppBar(),
        body: Padding(
          padding: PaddingUtility.scaffoldGeneralPaddingOnlyTRL,
          child: Container(
            padding: PaddingUtility.paddingTop10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          //height: 650,
                          child: isLoading == true
                              ? const Center(child: Text('B00KS ARE LOADING'))
                              : BookList(books),
                        ),
                      ),
                    ],
                  ),
                ),
                //Expanded(flex: 1, child: Container())
                /*Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 4),
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddBookByPage()));
                      },
                    ),
                  ),*/
              ],
            ),
          ),
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          children: [
            SpeedDialChild(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          //builder: (context) => AddNotePage(widget.bookId)));
                          builder: (context) => AddBookPage()));
                },
                child: const Icon(
                  (Icons.note),
                ),
                label: "Manual Entry"),
            SpeedDialChild(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScanBookPage()));
                },
                child: const Icon(Icons.insert_photo),
                label: "Scan Barcode"),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(items: const [
          BottomNavigationBarItem(icon: Icon(null), label: ''),
          BottomNavigationBarItem(icon: Icon(null), label: '')
        ],elevation: 10,backgroundColor: ColorsUtility.appBarBackgroundColor),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: Container(
          padding: EdgeInsets.all(8),
          child: FittedBox(child: Image.asset("assets/logo.png"))),
      title: Text(
        "Books",
        style: TextStyle(color: ColorsUtility.appBarTitleColor),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.language,
                color: ColorsUtility.appBarIconColor,
              )),
        )
      ],
    );
  }

  Future refreshBooks() async {
    /*print("listing books:");

    books = await NotesDatabase.instance.readAllBooks();

    for (int i = 0; i < books.length; i++) {
      print(
          'BOOK ID: ${books[i].bookId}, BOOK NAME: ${books[i].bookName}, BOOK AUTHOR: ${books[i].bookAuthor}, DATE ADDED: ${books[i].dateAdded}');
    }*/
    books = [];
    setState(() {
      isLoading = false;
    });
  }
}
