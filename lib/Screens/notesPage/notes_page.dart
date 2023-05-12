import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_notes/NoteSheets/image_to_text_sheet.dart';
import 'package:my_notes/NoteSheets/speech_to_text_sheet.dart';
import 'package:my_notes/Screens/addNotePage/add_image_page.dart';
import 'package:my_notes/Screens/addNotePage/add_note_page.dart';
import 'package:my_notes/Screens/addNotePage/add_speech_page.dart';
import 'package:my_notes/Screens/addNotePage/scan_text_page.dart';
import 'package:my_notes/Screens/addNotePage/speech_to_text_page.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/TextStyleUtility.dart';
import 'package:my_notes/controllers/book_controller.dart';
import 'package:my_notes/controllers/note_controller.dart';
import 'package:my_notes/enums/noteActionEnums.dart';
import 'package:my_notes/enums/noteTypeEnums.dart';
import 'package:my_notes/widgets/addNotePagesAppBar.dart';

import '../../Databases/NotesDatabase.dart';
import '../../Models/Book.dart';
import '../../Models/Note.dart';
import '../../NoteSheets/manuel_entry_sheet.dart';
import '../../Utils/FontSizeUtility.dart';
import '../../Utils/PaddingUtility.dart';
import '../bookPage/books_page.dart';
import 'notes_list.dart';
import 'package:get/get.dart';
import '../../lang/translation_keys.dart' as translation;
import 'package:my_notes/extensions/string_extension.dart';

class NotesPage extends StatefulWidget {
  final Book book;

  const NotesPage(this.book, {Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late bool isLoading;
  late List<Note> notes;

  //NoteController noteController = Get.put(NoteController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //isLoading = true;
    isLoading = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("notespage dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Future.value(true),
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
                            //decoration: BoxDecoration(color: Colors.black),
                            child: isLoading == true
                                ? const Center(child: Text('NOTES ARE LOADING'))
                                : NotesList(
                                    notes: [],
                                    book: widget.book!,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: SpeedDial(
            //childrenButtonSize: Size(Get.width * 2 / 10, 65),
            direction: SpeedDialDirection.up,
            icon: Icons.add,
            switchLabelPosition: false,
            label: Text(translation.addNote.locale),
            activeIcon: Icons.close,
            childMargin: EdgeInsets.zero,
            childPadding: const EdgeInsets.only(left: 5),
            spaceBetweenChildren: 10,
            children: [
              SpeedDialChild(
                  backgroundColor: ColorsUtility.blackText,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 8 / 10,
                              width: MediaQuery.of(context).size.width,
                              child: const ManuelEntrySheet(
                                noteAction: NoteAction.noteAdd,
                              ));
                        });
                  },
                  child: Icon(
                    color: ColorsUtility.scaffoldBackgroundColor,
                    (Icons.note),
                  ),
                  label: translation.manualNote.locale,
                  labelBackgroundColor: ColorsUtility.blackText,
                  labelStyle: TextStyleUtility.profileInfoTextStyle
                      .copyWith(color: ColorsUtility.scaffoldBackgroundColor)),
              SpeedDialChild(
                  backgroundColor: ColorsUtility.blackText,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 8 / 10,
                              child: const AddImagePage());
                        });
                  },
                  child: Icon(
                    Icons.insert_photo,
                    color: ColorsUtility.scaffoldBackgroundColor,
                  ),
                  label: translation.imageNote.locale,
                  labelBackgroundColor: ColorsUtility.blackText,
                  labelStyle: TextStyleUtility.profileInfoTextStyle
                      .copyWith(color: ColorsUtility.scaffoldBackgroundColor)),
              SpeedDialChild(
                  backgroundColor: ColorsUtility.blackText,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 8 / 10,
                            child: ImageToTextSheet(widget.book),
                          );
                        });
                  },
                  child: Icon(
                    Icons.insert_photo,
                    color: ColorsUtility.scaffoldBackgroundColor,
                  ),
                  label: translation.imageToTextNote.locale,
                  labelBackgroundColor: ColorsUtility.blackText,
                  labelStyle: TextStyleUtility.profileInfoTextStyle
                      .copyWith(color: ColorsUtility.scaffoldBackgroundColor)),
              SpeedDialChild(
                  backgroundColor: ColorsUtility.blackText,
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 8 / 10,
                            child: SpeechToTextSheet(book: widget.book),
                          );
                        });
                  },
                  child: const Icon(Icons.mic),
                  label: translation.audioToTextNote.locale,
                  labelBackgroundColor: ColorsUtility.blackText,
                  labelStyle: TextStyleUtility.profileInfoTextStyle
                      .copyWith(color: ColorsUtility.scaffoldBackgroundColor)),
              SpeedDialChild(
                  backgroundColor: ColorsUtility.blackText,
                  onTap: () {
                    buildRecordVoiceBottomSheet(context);
                  },
                  child: Icon(
                    Icons.mic,
                    color: ColorsUtility.scaffoldBackgroundColor,
                  ),
                  label: translation.audioNote.locale,
                  labelBackgroundColor: ColorsUtility.blackText)
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(null), label: ''),
              BottomNavigationBarItem(icon: Icon(null), label: '')
            ],
            elevation: 10,
            backgroundColor: ColorsUtility.appBarBackgroundColor,
          ),
        ));
  }

  void buildRecordVoiceBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * 8 / 10,
              child: const AddSpeechPage(
                noteAction: NoteAction.noteAdd,
              ));
        });
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        widget.book.bookName.toString(),
        style: TextStyle(color: ColorsUtility.appBarTitleColor, overflow: TextOverflow.ellipsis, fontSize: FontSizeUtility.font20),
      ),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: ColorsUtility.appBarIconColor,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      actions: [
        IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: ColorsUtility.scaffoldBackgroundColor,
                    title: Text(
                      'Confirm Delete',
                      style: TextStyleUtility.textStyleBookInfoDialog,
                    ),
                    content: Text('Are you sure you want to delete this book?',
                        style: TextStyleUtility.textStyleBookInfoDialog),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel',
                            style: TextStyleUtility.textStyleBookInfoDialog),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Delete',
                            style: TextStyleUtility.dangerTextStyle),
                      ),
                    ],
                  );
                },
              ).then((confirmed) async {
                if (confirmed != null && confirmed) {
                  // Code to delete the document goes here
                  await Get.find<BookController>().deleteBook(widget.book);
                  Get.off(() => const BooksPage());
                }
              });
            },
            icon: Icon(
              Icons.delete,
              color: ColorsUtility.redColor,
            ))
      ],
    );
  }
}
