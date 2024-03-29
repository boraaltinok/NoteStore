import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/FontSizeUtility.dart';
import 'package:my_notes/Utils/PaddingUtility.dart';
import 'package:my_notes/Utils/TextStyleUtility.dart';

import '../../Models/Note.dart';
import 'package:timeago/timeago.dart' as timeago;

class ImageCard extends StatelessWidget {
  final Note note;

  const ImageCard({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('ru', timeago.EnMessages());
    return Container(
      decoration: BoxDecoration(
        color: ColorsUtility.transparentColor,
      ),
      constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.25,
          maxHeight: MediaQuery.of(context).size.height * 0.25),
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      child: Card(
        color: ColorsUtility.scaffoldBackgroundColor,
        elevation: 8,
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Stack(
                children: [
                  Positioned(
                    right: 0.0,
                    top: 0.0,
                    left: 0.0,
                    bottom: 0.0,
                    child: FittedBox(
                      clipBehavior: Clip.hardEdge,
                      fit: BoxFit.cover,
                      child: CachedNetworkImage(
                        imageUrl: note.imagePath.toString(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    left: 0.0,
                    child: note.noteTitle.toString() == ""
                        ? const SizedBox(
                            width: 0,
                            height: 0,
                          )
                        : Container(
                            decoration:
                                BoxDecoration(color: Colors.black87.withOpacity(0.6)),
                            padding: PaddingUtility.paddingTransparentCardArea,
                            child: Row(
                              children: [
                                Text(note.noteTitle.toString(),
                                    style: TextStyleUtility.textStyleNoteCardTitle)
                              ],
                            ),
                          ),
                  ),
                  /*Positioned(
                      bottom: 5.0,
                      left: 5.0,
                      child: Text(
                        timeago.format(note.dateAdded),
                        style: TextStyleUtility.textStyleDate,
                      ))*/
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: ColorsUtility.whiteTextColor,
                child: Padding(
                  padding: PaddingUtility.paddingTextLeftRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        timeago.format(note.dateAdded, locale: Get.locale?.languageCode ?? Get.fallbackLocale?.languageCode?? 'en'),
                        style: TextStyleUtility.textStyleDate.copyWith(color: ColorsUtility.hintTextColor),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
