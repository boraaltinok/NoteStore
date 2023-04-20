import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/PaddingUtility.dart';
import 'package:my_notes/Utils/TextStyleUtility.dart';

import '../../Models/Note.dart';
import 'package:timeago/timeago.dart' as timeago;

class ManuelCard extends StatelessWidget {
  final Note note;

  const ManuelCard({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.25,
          maxHeight: MediaQuery.of(context).size.height * 0.25),
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      child: Card(
        color: ColorsUtility.whiteTextColor,
        elevation: 8,
        child: note.noteTitle.toString() == ""
            ? Column(
          children: [
            Expanded(
              flex: 10,
              child: Padding(
                padding: PaddingUtility.paddingTextLeftRight,
                child: Text(note.noteText, style: TextStyleUtility.textStyleBookInfoDialog,),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    timeago.format(note.dateAdded),
                    style: TextStyleUtility.textStyleDate.copyWith(color: Colors.grey),
                  ),
                ),
              ),
            )
          ],
        )
            : Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black87.withOpacity(0.6)),
                padding: PaddingUtility.paddingTransparentCardArea,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(note.noteTitle.toString(),
                          overflow: TextOverflow.ellipsis,
                          style:
                          TextStyleUtility.textStyleNoteCardTitle),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: PaddingUtility.paddingTextLeftRight,
                child: Text(note.noteText, style: TextStyleUtility.textStyleBookInfoDialog,),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    timeago.format(note.dateAdded),
                    style: TextStyleUtility.textStyleDate.copyWith(color: Colors.grey),
                  ),
                ),
              ),
            )
          ],
        ),)
        /*Stack(
          children: [
            /*Positioned(
              child: Padding(
                padding: PaddingUtility.scaffoldBodyGeneralPadding,
                child: Column(children: [
                  Text(note.noteText)
                ],),
              ),
            ),*/
            Positioned(
              top: 0.0,
              right: 0.0,
              left: 0.0,
              child: note.noteTitle.toString() == ""
                  ? const SizedBox(
                      width: 0,
                      height: 0,
                    )
                  : Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black87.withOpacity(0.6)),
                          padding: PaddingUtility.paddingTransparentCardArea,
                          child: Row(
                            children: [
                              Text(note.noteTitle.toString(),
                                  style:
                                      TextStyleUtility.textStyleNoteCardTitle)
                            ],
                          ),
                        ),
                        Padding(
                          padding: PaddingUtility.paddingTextLeftRight,
                          child: Text(note.noteText, style: TextStyleUtility.textStyleBookInfoDialog,),
                        )
                      ],
                    ),
            ),
            Positioned(
                bottom: 5.0,
                left: 5.0,
                child: Text(
                  timeago.format(note.dateAdded),
                  style: TextStyleUtility.textStyleDate,
                ))
          ],
        ),*/
      );
  }
}
