import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../Models/Note.dart';
import '../constants.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class NoteController extends GetxController {
  final Rx<List<Note>> _noteList = Rx<List<Note>>([]);
  final Rx<String> _bookId = Rx<String>("");
  final Rx<String> _imagePath = Rx<String>("");
  final Rx<String> _speechPath = Rx<String>("");

  List<Note> get noteList => _noteList.value;

  String get bookId => _bookId.value;

  String get imagePath => _imagePath.value;

  String get speechPath => _speechPath.value;

  @override
  void onInit() {
    super.onInit();
    print("bookID value is ${_bookId.value}");
  }

  updateBookId(String bookId) {
    _bookId.value = bookId;

    _noteList.bindStream(firestore
        .collection('users')
        .doc(authController.user.uid)
        .collection('books')
        .doc(_bookId.value)
        .collection("notes")
        .snapshots()
        .map((QuerySnapshot query) {
      List<Note> retVal = [];
      for (var element in query.docs) {
        retVal.add(Note.fromSnap(element));
      }
      return retVal;
    }));
  }

  setImagePath(String path) {
    _imagePath.value = path;
  }

  setSpeechPath(String path) {
    _speechPath.value = path;
  }

  uploadNote(
      {required String bookId,
      noteTitle,
      notePage,
      required String noteText,
      String imagePath = '',
      String speechPath = '',
      required String noteType}) async {
    try {
      String uid = firebaseAuth.currentUser!.uid; //find current users uid
      String randomId = const Uuid().v4();

      DocumentSnapshot bookDoc = await firestore
          .collection('users')
          .doc(uid)
          .collection('books')
          .doc(bookId)
          .get();

      //String videoUrl = await _uploadVideoToStorage("Video $len", videoPath);
      String imageURL = "";
      String speechURL = "";
      if (imagePath != "") {
        imageURL = await _uploadImageNoteToStorage(randomId, imagePath);
      }
      if (speechPath != "") {
        speechURL = await _uploadSpeechNoteToStorage(randomId, speechPath);
      }

      Note note = Note(
          noteId: randomId,
          bookId: bookId,
          addedBy: '',
          noteType: noteType,
          noteText: noteText,
          imagePath: imageURL,
          speechPath: speechURL,
          dateAdded: DateTime.now());

      await firestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('books')
          .doc(bookId)
          .collection('notes')
          .doc(randomId)
          .set(note.toJson());
      /*if (speechPath != "") {
        String bookCoverUrl =
        await _uploadBookCoverToStorage(randomId, bookCoverPath);
      }*/
      return speechURL == "" ? imageURL : speechURL;
    } catch (e) {
      Get.snackbar('Error Uploading Note', e.toString());
    }
  }

  Future<String> _uploadImageNoteToStorage(String id, String imagePath) async {
    Reference ref = firebaseStorage.ref().child('imageNotes').child(id);

    UploadTask uploadTask = ref.putFile(File(imagePath));

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> _uploadSpeechNoteToStorage(
      String id, String speechPath) async {
    //print("inside uploadSpeechNoteToStorage");
    Reference ref = firebaseStorage.ref().child('speechNotes').child(id);

    UploadTask uploadTask = ref.putFile(
        File(speechPath), SettableMetadata(contentType: 'audio/wav'));

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<File> _fileFromImageUrl(String bookCoverUrl) async {
    final response = await http.get(Uri.parse(bookCoverUrl));

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(join(documentDirectory.path, 'imagetest.png'));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }
}
