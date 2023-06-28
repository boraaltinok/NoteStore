import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:my_notes/Screens/bookPage/books_page.dart';
import 'package:my_notes/Utils/PaddingUtility.dart';
import 'package:my_notes/constants.dart';
import 'package:my_notes/widgets/addNotePagesAppBar.dart';

import '../../Databases/NotesDatabase.dart';
import '../../Models/Book.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../Utils/ColorsUtility.dart';
import '../../controllers/book_controller.dart';
import '../../widgets/addBookPageAppBar.dart';

import '../../lang/translation_keys.dart' as translation;
import 'package:my_notes/extensions/string_extension.dart';

class AddBookPage extends StatefulWidget {
  AddBookPage({Key? key}) : super(key: key);

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final formKey = GlobalKey<FormState>();
  BookController bookController = Get.put(BookController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookController.initTextEditingControllers();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    bookController.disposeTextEditingControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    TextEditingController bookNameEditingController = TextEditingController();
    TextEditingController bookAuthorEditingController = TextEditingController();

    BookController bookController = Get.put(BookController());

    ScrollController _scrollController =
    ScrollController(initialScrollOffset: 0);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AddBookPageAppBar(),
      body: Padding(
          padding: PaddingUtility.scaffoldBodyGeneralPadding,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: PaddingUtility.scaffoldBodyGeneralPadding,
                  child: SizedBox(
                    height: kToolbarHeight,
                    child: TextField(
                      controller: bookController.bookTitleController,
                      keyboardType: TextInputType.multiline,
                      //maxLines: 10,
                      maxLines: 1,
                      decoration: InputDecoration(
                        contentPadding: PaddingUtility.paddingTextLeftRight * 2,
                        labelText: "Book Title",
                        labelStyle:
                        TextStyle(color: ColorsUtility.hintTextColor),
                        enabledBorder: const OutlineInputBorder(),),
                      style: TextStyle(color: ColorsUtility.blackText),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: PaddingUtility.scaffoldBodyGeneralPadding,
                  child: SizedBox(
                    height: kToolbarHeight,
                    child: TextField(
                      controller: bookController.bookAuthorController,
                      keyboardType: TextInputType.multiline,
                      //maxLines: 10,
                      maxLines: 1,
                      decoration: InputDecoration(
                          contentPadding: PaddingUtility.paddingTextLeftRight * 2,
                          labelText: "Author Name",
                          labelStyle:
                          TextStyle(color: ColorsUtility.hintTextColor),
                          enabledBorder: const OutlineInputBorder()),
                      style: TextStyle(color: ColorsUtility.blackText),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Obx(() {
                          return Container(
                            width: MediaQuery.of(context).size.width * 6 / 10,
                            height: MediaQuery.of(context).size.height * 4 / 10,
                            color: Colors.grey,
                            child: (bookController.bookManualPhotoPath != "") ? FittedBox(
                                fit: BoxFit.contain,
                                child: Image.file(
                                    File(bookController.bookManualPhotoPath))) : const SizedBox(height: 0, width: 0,),
                          );
                        }
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: PaddingUtility.paddingTextLeftRight,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          onPrimary: Colors.grey,
                                          shadowColor: Colors.grey[400],
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0)),
                                        ),
                                        onPressed: () {
                                          bookController.pickImage(ImageSource.camera);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.camera_alt,
                                                size: 30,
                                              ),
                                              Text(
                                                translation.camera.locale,
                                                style: TextStyle(
                                                    fontSize: 13, color: Colors.grey[600]),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: PaddingUtility.paddingTextLeftRight,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          onPrimary: Colors.grey,
                                          shadowColor: Colors.grey[400],
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0)),
                                        ),
                                        onPressed: () {
                                          bookController.pickImage(ImageSource.gallery);
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.image,
                                                size: 30,
                                              ),
                                              Text(
                                                translation.gallery.locale,
                                                style: TextStyle(
                                                    fontSize: 13, color: Colors.grey[600]),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      )
                    ],
                  ))
            ],
          ) /*Column(
          children: [
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
                            bookController.uploadBook(
                                bookName: bookNameEditingController.text,
                                bookAuthor: bookAuthorEditingController.text);
                            /*addBook(bookNameEditingController.text,
                                bookAuthorEditingController.text);*/
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BooksPage()));
                          }
                        },
                        label: const Text(
                          "ADD THE BOOK",
                        ),
                        backgroundColor: borderColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),*/
      ),
    );
  }

  Future<Book> addBook(String bookName, String bookAuthor) async {
    print("ADDING A BOOK");
    Book newBook = Book(
        bookAuthor: bookAuthor,
        bookName: bookName,
        dateAdded: DateTime.now(),
        userId: authController.user.uid);
    return NotesDatabase.instance.createBook(newBook);
  }
}