import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_notes/Screens/book_list.dart';
import 'package:my_notes/Screens/scan_book_page.dart';


import '../Databases/NotesDatabase.dart';
import '../Models/Book.dart';
import 'add_book_page.dart';

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
          body: Container(
            decoration: const BoxDecoration(color: Color(0xffffffff)),
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Image(image: AssetImage("assets/logo3.png"))
                      /*Text(
                        "LOGO",
                        style: TextStyle(fontSize: 35),
                      )*/
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          height: 650,
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: const BoxDecoration(color: Colors.black),
                          child: isLoading == true
                              ? const Center(child: Text('B00KS ARE LOADING'))
                              : BookList(books),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded( flex: 1,child: Container())
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
                  label: "Manual Gir"),
              SpeedDialChild(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScanBookPage()));
                  },
                  child: const Icon(Icons.insert_photo),
                  label: "Barkod Okut"),
            ],
          )),
    );
  }

  Future refreshBooks() async {
    print("listing books:");

    books = await NotesDatabase.instance.readAllBooks();

    for (int i = 0; i < books.length; i++) {
      print(
          'BOOK ID: ${books[i].bookId}, BOOK NAME: ${books[i].bookName}, BOOK AUTHOR: ${books[i].bookAuthor}, DATE ADDED: ${books[i].dateAdded}');
    }
    setState(() {
      isLoading = false;
    });
  }
}
