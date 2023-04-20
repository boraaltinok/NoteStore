import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/SnackBarUtility.dart';
import 'package:my_notes/enums/noteActionEnums.dart';
import 'package:my_notes/enums/noteTypeEnums.dart';
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

  late TextEditingController _noteTitleController;
  late TextEditingController _noteTextEditingController;

  TextEditingController get noteTitleController => _noteTitleController;

  TextEditingController get noteTextEditingController =>
      _noteTextEditingController;

  List<Note> get noteList => _noteList.value;

  String get bookId => _bookId.value;

  String get imagePath => _imagePath.value;

  String get speechPath => _speechPath.value;

  late Note currentNote;

  @override
  void onInit() {
    super.onInit();
    print("bookID value is ${_bookId.value}");
  }

  initTextEditingControllers({required NoteAction noteAction, Note? note}) {
    if (noteAction == NoteAction.noteAdd) {
      _noteTitleController = TextEditingController();
      _noteTextEditingController = TextEditingController();
    } else if (noteAction == NoteAction.noteEdit) {
      _noteTitleController =
          TextEditingController(text: note?.noteTitle.toString());
      _noteTextEditingController =
          TextEditingController(text: note?.noteText.toString());
    }
  }

  updateCurrentNote(Note note) {
    currentNote = note;
  }

  resetTextEditingControllers() {
    _noteTitleController.text = "";
    _noteTextEditingController.text = "";
  }

  disposeTextEditingControllers() {
    _noteTitleController.dispose();
    _noteTextEditingController.dispose();
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
      retVal.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
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
      {noteTitle = '',
      notePage,
      String noteText = '',
      String imagePath = '',
      String speechPath = '',
      int speechDuration = 0,
      required NoteTypeEnum noteTypeEnum}) async {
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
          noteType: noteTypeEnum.noteTypeEnumToString(),
          noteText: noteTextEditingController.text,
          noteTitle: noteTitleController.text,
          imagePath: imageURL,
          speechPath: speechURL,
          dateAdded: DateTime.now(),
          speechDuration: speechDuration);

      await firestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('books')
          .doc(bookId)
          .collection('notes')
          .doc(randomId)
          .set(note.toJson());
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

  Future editNote({String? noteTitle, String? noteText}) async {
    String? newNoteTitle = currentNote.noteTitle;
    String? newNoteText = currentNote.noteText;

    if (noteTitle != currentNote.noteTitle) {
      newNoteTitle = noteTitle;
    }
    if (noteText != currentNote.noteText) {
      newNoteText = noteText;
    }
    if (noteTitle != currentNote.noteTitle ||
        noteText != currentNote.noteText) {
      print("currentNote ıd ${currentNote.noteId}");
      await firestore
          .collection('users')
          .doc(authController.user.uid)
          .collection('books')
          .doc(bookId)
          .collection('notes')
          .doc(currentNote.noteId)
          .update({
        NoteFields.noteTitle: newNoteTitle,
        NoteFields.noteText: newNoteText
      });
    }
  }

  Future deleteNote(
      {required Note note}) async {
    if(note.speechPath != ""){
      await firebaseStorage.refFromURL(note.speechPath?? "").delete();
    }
    if(note.imagePath != ""){
      await firebaseStorage.refFromURL(note.imagePath?? "").delete();

    }
    await firestore
        .collection('users')
        .doc(authController.user.uid)
        .collection('books')
        .doc(note.bookId)
        .collection('notes')
        .doc(note.noteId)
        .delete();

    //Get.snackbar("", "Note deleted successfully", );
    SnackBarUtility.showCustomSnackbar(title: 'NoteStore Notification', message: 'Note deleted successfully',icon: Icon(Icons.check_circle_outline, color: ColorsUtility.appBarIconColor,));
  }
}
