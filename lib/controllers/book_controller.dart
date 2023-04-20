import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/SnackBarUtility.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../Models/Book.dart';
import '../Models/Note.dart';
import '../constants.dart';
import 'dart:io';

class BookController extends GetxController {
  final Rx<List<Book>> _bookList = Rx<List<Book>>([]);

  late TextEditingController _bookTitleController;
  late TextEditingController _bookAuthorController;

  TextEditingController get bookTitleController => _bookTitleController;

  TextEditingController get bookAuthorController => _bookAuthorController;

  Rx<bool> _bookLongPressed = false.obs;

  List<Book> get bookList => _bookList.value;

  bool get bookLongPressed => _bookLongPressed.value;

  @override
  void onInit() {
    super.onInit();
    _bookList.bindStream(firestore
        .collection('users')
        .doc(authController.user.uid)
        .collection('books')
        .snapshots()
        .map((QuerySnapshot query) {
      List<Book> retVal = [];
      for (var element in query.docs) {
        retVal.add(Book.fromSnap(element));
      }
      return retVal;
    }));
  }

  initTextEditingControllers() {
    _bookAuthorController = TextEditingController();
    _bookTitleController = TextEditingController();
  }

  disposeTextEditingControllers() {
    _bookAuthorController.dispose();
    _bookTitleController.dispose();
  }

  void onBookLongPressed() {
    _bookLongPressed = (!_bookLongPressed.value).obs;
    print("here value is ${_bookLongPressed.value}");
  }

  Future<File> _fileFromImageUrl(String bookCoverUrl) async {
    final response = await http.get(Uri.parse(bookCoverUrl));

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(join(documentDirectory.path, 'imagetest.png'));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }

  Future<String> _uploadBookCoverToStorage(
      String id, String bookCoverPath) async {
    Reference ref = firebaseStorage.ref().child('bookCovers').child(id);

    UploadTask uploadTask = ref.putFile(await _fileFromImageUrl(bookCoverPath));

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadBook(
      {required String bookName,
      required String bookAuthor,
      String bookCoverPath = ""}) async {
    //isLoading.value = true;
    if (bookName == "" || bookAuthor == "") {
      SnackBarUtility.showCustomSnackbar(
          title: "Can't Add the Book",
          message: "Please fill all the fields",
          icon: Icon(
            Icons.error_outline_outlined,
            color: ColorsUtility.appBarIconColor,
          ));
      return;
    }
    try {
      String uid = firebaseAuth.currentUser!.uid; //find current users uid

      String randomId = const Uuid().v4();
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();
      // get id
      var allDocs = await firestore.collection('books').get();
      int len = allDocs.docs.length;
      //String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String bookCoverFirebaseUrl = "";
      if (bookCoverPath != "") {
        bookCoverFirebaseUrl =
            await _uploadBookCoverToStorage(randomId, bookCoverPath);
      }

      /*String thumbnailUrl =
      await _uploadImageToStorage("Video $len", videoPath);*/
      Book book = Book(
          userId: authController.user.uid,
          dateAdded: DateTime.now(),
          bookName: bookName,
          bookAuthor: bookAuthor,
          bookCover: bookCoverFirebaseUrl,
          bookId: randomId);

      //await firestore.collection('books').doc('Book $len').set(book.toJson());
      await firestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('books')
          .doc(book.bookId)
          .set(book.toJson());

      /*Video video = Video(
          username: (userDoc.data()! as Map<String, dynamic>)['name'],
          uid: uid,
          id: "Video $len",
          likes: [],
          commentCount: 0,
          sharedCount: 0,
          videoName: videoName,
          caption: caption,
          videoUrl: videoUrl,
          thumbnailUrl: thumbnailUrl,
          profilePhoto:
              (userDoc.data()! as Map<String, dynamic>)['profilePhoto']);*/

      /*await firestore
          .collection('videos')
          .doc('Video $len')
          .set(video.toJson());*/
      //Get.back();
    } catch (e) {
      Get.snackbar('Error Uploading Book', e.toString());
    }
    //isLoading.value = false;
  }

  deleteBook(Book book) async {
    final DocumentSnapshot documentSnapshot = await firestore
        .collection('users')
        .doc(authController.user.uid)
        .collection('books')
        .doc(book.bookId)
        .get();
    Book toBeDeletedBook = Book.fromSnap(documentSnapshot);
    try{
      await firebaseStorage
          .refFromURL(toBeDeletedBook.bookCover ?? "")//deleting the book cover
          .delete();
    }catch(e){
      print(e);
    }
    final QuerySnapshot noteSnapshots = await firestore
        .collection('users')
        .doc(authController.user.uid)
        .collection('books')
        .doc(book.bookId)
        .collection('notes')
        .get();

    for (final DocumentSnapshot noteSnapshot in noteSnapshots.docs) {
      Note toBeDeletedNote = Note.fromSnap(noteSnapshot);
      if (toBeDeletedNote.imagePath != null &&
          toBeDeletedNote.imagePath != "") {
        try {
          await firebaseStorage
              .refFromURL(toBeDeletedNote.imagePath ?? "")//deleting the image file from storage
              .delete();
        } catch (e) {
          print(e);
        }
      }
      if (toBeDeletedNote.speechPath != null &&
          toBeDeletedNote.speechPath != "") {
        try {
          await firebaseStorage
              .refFromURL(toBeDeletedNote.speechPath ?? "")//deleting the speech file from storage
              .delete();
        } catch (e) {
          print(e);
        }
      }
    }
    final CollectionReference collectionRef = firestore
        .collection('users')
        .doc(authController.user.uid)
        .collection('books')
        .doc(book.bookId)
        .collection('notes');

    await collectionRef.get().then((querySnapshot) {
      for (var note in querySnapshot.docs) {
        note.reference.delete();
      }
    });

    await firestore
        .collection('users')
        .doc(authController.user.uid)
        .collection('books')
        .doc(book.bookId)
        .delete();
  }
}
