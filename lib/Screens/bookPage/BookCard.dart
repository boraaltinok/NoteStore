import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/Models/Book.dart';
import 'package:intl/intl.dart';
import 'package:my_notes/Utils/BorderUtility.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/Dimensions.dart';
import 'package:my_notes/Utils/LocalizationUtility.dart';
import 'package:my_notes/Utils/PaddingUtility.dart';
import 'package:my_notes/Utils/TextStyleUtility.dart';
import 'package:my_notes/constants.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../lang/translation_keys.dart' as translation;
import 'package:my_notes/extensions/string_extension.dart';

import '../../controllers/book_controller.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final Function onDelete;

  const BookCard({required this.book, required this.onDelete, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    timeago.setLocaleMessages('en', timeago.EnMessages());
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ClipRRect(
          borderRadius: BorderUtility.borderCircularTRightBRight25,
          child: Stack(
            children: [
              buildBookCard(constraints),
              buildPositionedInfoButton(context)
            ],
          ),
        );
      },
    );
  }

  Positioned buildPositionedInfoButton(BuildContext context) {
    return Positioned(
        right: 0,
        bottom: 0,
        child: IconButton(
            onPressed: () {
              onInfoPressed(context);
            },
            icon: Icon(
              Icons.info_sharp,
              color: ColorsUtility.appBarIconColor,
              size: Dimensions.iconSize24,
            )));
  }

  Card buildBookCard(BoxConstraints constraints) {
    return Card(
      elevation: 8,
      //color: const Color(0xff68c1bc),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: SizedBox(
              width: constraints.maxWidth,
              //height: constraints.maxHeight / 2,
              child: FittedBox(
                fit: BoxFit.fill,
                child: buildCoverImage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onInfoPressed(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return buildBookInfoDialog(context);
        });
  }

  Dialog buildBookInfoDialog(BuildContext context) {
    return Dialog(
      backgroundColor: ColorsUtility.scaffoldBackgroundColor,
      child: Padding(
        padding: PaddingUtility.dialogGeneralPadding,
        child: Container(
            width: MediaQuery.of(context).size.width * 3 / 10,
            height: MediaQuery.of(context).size.height * 4 / 10,
            decoration: BoxDecoration(
                borderRadius: BorderUtility.borderCircular25,
                color: ColorsUtility.scaffoldBackgroundColor),
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Center(
                    child: buildCoverImageArea(context),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "${translation.name.locale}: ${book.bookName.toString()}",
                            style: TextStyleUtility.textStyleBookInfoDialog))),
                Expanded(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${translation.author.locale}:  ${book.bookAuthor.toString()}",
                          style: TextStyleUtility.textStyleBookInfoDialog,
                        ))),
                Expanded(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            Get.locale?.languageCode ==
                                    LocalizationUtility.EN_LOCALE.languageCode
                                ? "${translation.added.locale} ${timeago.format(book.dateAdded, locale: Get.locale?.languageCode ?? Get.fallbackLocale?.languageCode ?? 'en')}"
                                : Get.locale?.languageCode ==
                                        LocalizationUtility
                                            .TR_LOCALE.languageCode
                                    ? "${timeago.format(book.dateAdded, locale: Get.locale?.languageCode ?? Get.fallbackLocale?.languageCode ?? 'en')} ${translation.added.locale}"
                                    : "Error",
                            style: TextStyleUtility.textStyleBookInfoDialog)))
              ],
            )),
      ),
    );
  }

  SizedBox buildCoverImageArea(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 3 / 10,
      child: FittedBox(
        fit: BoxFit.fill,
        child: buildCoverImage(),
      ),
    );
  }

  CachedNetworkImage? buildCoverImage() {
    return book.bookCover != ""
        ? CachedNetworkImage(
            imageUrl: book.bookCover!,
            fit: BoxFit.cover,
          )
        : null;
    /*Image.network(
      book.bookCover == ""
          ? "https://firebasestorage.googleapis.com/v0/b/notestore-eea0e.appspot.com/o/bookCovers%2Fdefault_background.png?alt=media&token=67331278-4a75-402b-abd4-43deefbf4a58"
          : book.bookCover!,
      fit: BoxFit.cover,
    );*/
  }
}
