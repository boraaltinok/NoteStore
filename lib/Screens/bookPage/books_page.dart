import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_notes/Screens/bookPage/book_list.dart';
import 'package:my_notes/Screens/addBookPage/scan_book_page.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/DimensionsUtility.dart';
import 'package:my_notes/Utils/FontSizeUtility.dart';
import 'package:my_notes/Utils/LocalizationUtility.dart';
import 'package:my_notes/Utils/PaddingUtility.dart';
import 'package:my_notes/Utils/SnackBarUtility.dart';
import 'package:my_notes/Utils/TextStyleUtility.dart';
import 'package:my_notes/constants.dart';
import 'package:country_picker/country_picker.dart';

import '../../Models/Book.dart';
import '../../Models/user.dart';
import '../../controllers/language_controller.dart';
import '../../widgets/selectLanguagePopup.dart';
import '../addBookPage/add_book_page.dart';
import 'package:get/get.dart';

import '../../lang/translation_keys.dart' as translation;
import 'package:my_notes/extensions/string_extension.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({Key? key}) : super(key: key);

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  late Future<User?> _currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentUser =
        authController.getUser(userId: firebaseAuth.currentUser?.uid);
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  final GlobalKey _popupMenuKey = GlobalKey();


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
                                style: TextStyleUtility.textStyleBookInfoDialog
                                    .copyWith(fontSize: FontSizeUtility.font15),
                              ),
                              accountEmail: Text(
                                snapshot.data?.email ?? "DEFAULT",
                                style: TextStyleUtility.textStyleBookInfoDialog
                                    .copyWith(fontSize: FontSizeUtility.font15),
                              ),
                              currentAccountPicture: CircleAvatar(
                                radius: 70,
                                backgroundColor: ColorsUtility.hintTextColor,
                                backgroundImage: snapshot
                                    .data!.profilePhoto.isNotEmpty
                                    ? NetworkImage(snapshot.data!.profilePhoto)
                                    : null,
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
                    showPopupMenu(context, _popupMenuKey);
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.language,
                      color: ColorsUtility.appBarIconColor,
                    ),
                    title: Text(
                      translation.changeLanguage.locale,
                      style: TextStyleUtility.textStyleBookInfoDialog
                          .copyWith(fontSize: FontSizeUtility.font15),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: ColorsUtility.scaffoldBackgroundColor,
                          title: Text(
                            'Confirm Delete',
                            style: TextStyleUtility.textStyleBookInfoDialog,
                          ),
                          content: Text(translation.sureAboutAccountDeletion.locale,
                              style: TextStyleUtility.textStyleBookInfoDialog),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(translation.cancel.locale,
                                  style: TextStyleUtility.textStyleBookInfoDialog),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(translation.delete.locale,
                                  style: TextStyleUtility.dangerTextStyle),
                            ),
                          ],
                        );
                      },
                    ).then((confirmed) async {
                      if (confirmed != null && confirmed) {
                        SnackBarUtility.showCustomSnackbar(
                            title: translation.noteStoreNotification.locale,
                            message: translation.deletingYourAccount.locale,
                            icon: const Icon(Icons.delete_forever));
                        // Code to delete the document goes here
                        await authController.deleteAccount();
                        //Get.off(() => const LoginP());
                      }
                    });

                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.delete_forever,
                      color: ColorsUtility.appBarIconColor,
                    ),
                    title: Text(
                      translation.deleteAccount.locale,
                      style: TextStyleUtility.textStyleBookInfoDialog
                          .copyWith(fontSize: FontSizeUtility.font15),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    authController.signOut();
                    SnackBarUtility.showCustomSnackbar(
                        title: translation.noteStoreNotification.locale,
                        message: translation.logout.locale,
                        icon: const Icon(Icons.logout));
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: ColorsUtility.appBarIconColor,
                    ),
                    title: Text(
                      translation.logout.locale,
                      style: TextStyleUtility.textStyleBookInfoDialog
                          .copyWith(fontSize: FontSizeUtility.font15),
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
                    children: const [
                      Expanded(
                        child: BookList(),
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
                              height: 10 * kToolbarHeight,
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
                label: translation.manualEntry.locale),
            SpeedDialChild(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScanBookPage()));
                },
                child: const Icon(Icons.insert_photo),
                label: translation.scanBarcode.locale),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              if (index == 0) {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 8 / 10,
                            width: MediaQuery.of(context).size.width,
                            child: AddBookPage()),
                      );
                    });
              } else if (index == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScanBookPage()));
              }
            },
            unselectedItemColor: ColorsUtility.blackText,
            selectedItemColor: ColorsUtility.blackText,
            selectedLabelStyle:
            TextStyle(color: ColorsUtility.blackText, fontSize: 15),
            unselectedLabelStyle:
            TextStyle(color: ColorsUtility.blackText, fontSize: 15),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.book_rounded,
                    color: ColorsUtility.appBarIconColor,
                  ),
                  label: translation.addBookManually.locale,
                  backgroundColor: ColorsUtility.blackText),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    color: ColorsUtility.appBarIconColor,
                  ),
                  label: translation.scanISBNBarcode.locale)
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
        translation.books.locale,
        style: TextStyle(
            color: ColorsUtility.appBarTitleColor,
            fontSize: FontSizeUtility.font30),
      ),
      actions: [
        PopupMenuButton(

            key: _popupMenuKey,
            icon: Icon(
              Icons.language,
              color: ColorsUtility.appBarIconColor,
            ),
            onSelected: (value) {
              Get.find<LanguageController>()
                  .changeLanguage(
                  locale: value);

            },
            color: ColorsUtility.scaffoldBackgroundColor,
            elevation: 10,
            itemBuilder: (BuildContext bc) {
              final Country? turkey = Country.tryParse('turkey');
              final Country? us = Country.tryParse('us');
              final Country? russia = Country.tryParse('russia');
              return [
                PopupMenuItem(
                  value: LocalizationUtility.TR_LOCALE,
                  child: Text("${turkey?.flagEmoji ?? ""} ${translation.turkish.locale.toUpperCase()}", style: TextStyleUtility.textStyleBookInfoDialog,),
                ),
                PopupMenuItem(
                  value: LocalizationUtility.EN_LOCALE,
                  child: Text("${us?.flagEmoji ?? ""} ${translation.english.locale.toUpperCase()}", style: TextStyleUtility.textStyleBookInfoDialog,),
                ),
                PopupMenuItem(
                  value: LocalizationUtility.RU_LOCALE,
                  child: Text("${russia?.flagEmoji ?? ""} ${translation.russian.locale.toUpperCase()}", style: TextStyleUtility.textStyleBookInfoDialog,),
                )
              ];
            }),
        /*Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: InkWell(
              onTap: () {
                /*showDialog(context: context ,builder: (context){
                  return GestureDetector(onTap: () => Get.back(),child: SelectLanguagePopUp());
                });*/
              },
              child: Icon(
                Icons.language,
                color: ColorsUtility.appBarIconColor,
              )),
        )*/
      ],
    );
  }

  void showPopupMenu(BuildContext context, GlobalKey popupMenuKey) async {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RenderBox buttonBox = popupMenuKey.currentContext!.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        buttonBox.localToGlobal(Offset.zero, ancestor: overlay),
        buttonBox.localToGlobal(buttonBox.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    final Country? turkey = Country.tryParse('turkey');
    final Country? us = Country.tryParse('us');
    final Country? russia = Country.tryParse('russia');
    await showMenu(
      context: context,
      position: position,
      color: ColorsUtility.scaffoldBackgroundColor,
      elevation: 10,
      items: [
        PopupMenuItem(
          value: LocalizationUtility.TR_LOCALE,
          child: Text("${turkey?.flagEmoji ?? ""} ${translation.turkish.locale.toUpperCase()}", style: TextStyleUtility.textStyleBookInfoDialog,),
        ),
        PopupMenuItem(
          value: LocalizationUtility.EN_LOCALE,
          child: Text("${us?.flagEmoji ?? ""} ${translation.english.locale.toUpperCase()}", style: TextStyleUtility.textStyleBookInfoDialog,),
        ),
        PopupMenuItem(
          value: LocalizationUtility.RU_LOCALE,
          child: Text("${russia?.flagEmoji ?? ""} ${translation.russian.locale.toUpperCase()}", style: TextStyleUtility.textStyleBookInfoDialog,),
        ),
      ],
    ).then((selectedValue) {
      if (selectedValue != null) {
        Get.find<LanguageController>().changeLanguage(locale: selectedValue);
      }
    });
  }
}
