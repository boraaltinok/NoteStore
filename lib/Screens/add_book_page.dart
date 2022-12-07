import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_notes/Screens/books_page.dart';

import '../Databases/NotesDatabase.dart';
import '../Models/Book.dart';

class AddBookPage extends StatelessWidget {
  AddBookPage({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    TextEditingController bookNameEditingController = TextEditingController();
    TextEditingController bookAuthorEditingController = TextEditingController();

    ScrollController _scrollController =
        ScrollController(initialScrollOffset: 0);

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 30),
          //margin: EdgeInsets.fromLTRB(40, 40, 40, 80),
          decoration: const BoxDecoration(color: Color(0xffffffff)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BooksPage()));
                          },
                          icon: const Icon(Icons.arrow_circle_left),
                          iconSize: 25,
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                      flex: 1,
                      child: Image(
                          image: AssetImage("assets/logo3.png")))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Book Name',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          TextFormField(
                            controller: bookNameEditingController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please input book name';
                              }
                              return null;
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(75)
                            ],
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              hintText: "enter book name",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                            ),
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            maxLines: 2,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Book Author',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            thickness: 10,
                            radius: Radius.circular(15),
                            child: TextFormField(
                              controller: bookAuthorEditingController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please input book author';
                                }
                                return null;
                              },
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(70)
                              ],
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                hintText: "enter book author",
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                ),
                              ),
                              minLines: 1,
                              keyboardType: TextInputType.multiline,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              const snackBar = SnackBar(
                                  content: Text(
                                      'Book Have been Successfully Added'));

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              addBook(bookNameEditingController.text,
                                  bookAuthorEditingController.text);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const BooksPage()));
                            }
                          },
                          label: const Text(
                            "ADD THE BOOK",
                          ),
                          backgroundColor: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Book> addBook(String bookName, String bookAuthor) async {
    print("ADDING A BOOK");
    Book newBook = Book(
        bookAuthor: bookAuthor, bookName: bookName, dateAdded: DateTime.now());
    return NotesDatabase.instance.createBook(newBook);
  }
}
