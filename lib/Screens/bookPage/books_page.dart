import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_notes/Screens/bookPage/book_list.dart';
import 'package:my_notes/Screens/addBookPage/scan_book_page.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/DimensionsUtility.dart';
import 'package:my_notes/Utils/PaddingUtility.dart';
import 'package:my_notes/Utils/SnackBarUtility.dart';
import 'package:my_notes/Utils/TextStyleUtility.dart';
import 'package:my_notes/constants.dart';

import '../../Models/Book.dart';
import '../../Models/user.dart';
import '../addBookPage/add_book_page.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({Key? key}) : super(key: key);

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  late List<Book> books;
  late bool isLoading;
  late Future<User?> _currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    refreshBooks();
    _currentUser =
        authController.getUser(userId: firebaseAuth.currentUser?.uid);
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        key: _key,
        drawer: SizedBox(
          width: DimensionsUtility.drawerWidth,
          height: DimensionsUtility.screenHeight,
          child: Drawer(
            backgroundColor: ColorsUtility.scaffoldBackgroundColor,
            child: ListView(
              padding: PaddingUtility.scaffoldBodyGeneralPadding,
              children: [
                FutureBuilder<User?>(
                    future: _currentUser,
                    builder:
                        (BuildContext context, AsyncSnapshot<User?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return SizedBox(
                            height: DimensionsUtility.drawerProfileHeight,
                            child: UserAccountsDrawerHeader(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              accountName: Text(
                                snapshot.data?.name ?? "DEFAULT",
                                style: TextStyleUtility.textStyleBookInfoDialog,
                              ),
                              accountEmail: Text(
                                snapshot.data?.email ?? "DEFAULT",
                                style: TextStyleUtility.textStyleBookInfoDialog,
                              ),
                              currentAccountPicture: CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.blue,
                                backgroundImage:
                                    NetworkImage(snapshot.data!.profilePhoto),
                              ),
                            ),
                          );
                        } else {
                          return const Text('Unknown');
                        }
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
                GestureDetector(
                  onTap: () {
                    SnackBarUtility.showCustomSnackbar(
                        title: "pres", message: "press", icon: Icon(null));
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.language,
                      color: ColorsUtility.appBarIconColor,
                    ),
                    title: Text(
                      "Change language",
                      style: TextStyleUtility.textStyleBookInfoDialog,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    authController.signOut();
                    SnackBarUtility.showCustomSnackbar(
                        title: "NoteStore Notification",
                        message: "Logging out...",
                        icon: const Icon(Icons.logout));
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: ColorsUtility.appBarIconColor,
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyleUtility.textStyleBookInfoDialog,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: SizedBox(
                              height: 5 * kToolbarHeight,
                              width: MediaQuery.of(context).size.width,
                              child: AddBookPage()),
                        );
                      });
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          //builder: (context) => AddNotePage(widget.bookId)));
                          builder: (context) => AddBookPage()));*/
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
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index){
            if(index == 0){
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: SizedBox(
                          height: 5 * kToolbarHeight,
                          width: MediaQuery.of(context).size.width,
                          child: AddBookPage()),
                    );
                  });
            }else if(index == 1){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScanBookPage()));
            }
          },
            unselectedItemColor: ColorsUtility.blackText,
            selectedItemColor: ColorsUtility.blackText,
            selectedLabelStyle: TextStyle(color: ColorsUtility.blackText, fontSize: 15),
            unselectedLabelStyle: TextStyle(color: ColorsUtility.blackText, fontSize: 15),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.book_rounded,
                    color: ColorsUtility.appBarIconColor,
                  ),
                  label: 'Add Book Manually',
                  backgroundColor: ColorsUtility.blackText),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    color: ColorsUtility.appBarIconColor,
                  ),
                  label: 'Scan ISBN Barcode')
            ],
            elevation: 10,
            backgroundColor: ColorsUtility.appBarBackgroundColor),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      /*leading: Container(
          padding: EdgeInsets.all(8),
          child: FittedBox(child: Image.asset("assets/logo.png"))),*/
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: ColorsUtility.appBarIconColor,
        ),
        onPressed: () {
          print("here");
          _key.currentState?.openDrawer();
        },
      ),
      title: Text(
        "Books",
        style: TextStyle(color: ColorsUtility.appBarTitleColor),
      ),
      actions: [
        /*Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.language,
                color: ColorsUtility.appBarIconColor,
              )),
        )*/
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
