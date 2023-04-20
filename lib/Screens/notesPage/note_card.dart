
import 'package:flutter/material.dart';
import 'package:my_notes/Utils/TextStyleUtility.dart';
import 'package:my_notes/constants.dart';
import '../../Models/Note.dart';
import '../../Utils/ColorsUtility.dart';
import '../../Utils/PaddingUtility.dart';
import '../../controllers/speech_controller.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;


class NoteCard extends StatefulWidget {
  final Note note;
  final int index;
  final Function onDelete;
  final Function onView;
  final Function onEdit;

  NoteCard(
      {required this.note,
      required this.index,
      required this.onDelete,
      required this.onView,
      required this.onEdit,
      Key? key})
      : super(key: key);

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool isPlaying = false;

  late SpeechController speechController;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    speechController =
        Get.put(SpeechController(), tag: widget.index.toString());
    Future.delayed(Duration.zero, () async {
      await speechController.initRecorder();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return speechController.isRecorderReady == false
          ? Center(
              child: Text(
                "loading",
                style: TextStyleUtility.textStyleBookInfoDialog,
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.25,
                  maxHeight: MediaQuery.of(context).size.height * 0.25),
              //height: 80,
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              child: Card(
                color: ColorsUtility.cardBackgroundColor,
                elevation: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                              child: Text(widget.note.noteTitle.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                  TextStyleUtility.textStyleNoteCardTitle),
                            )
                          ],
                        ),
                      ),
                    ),
                    /*Expanded(
                flex: 1,
                child: Text(
                  "${widget.note.noteTitle}".toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Color(0xff00386B)),
                ),
                ),
                //Text(DateFormat('yyyy-MM-dd – kk:mm').format(note.dateAdded)),
                Expanded(
                flex: 1,
                child: Text(
                  widget.note.noteText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Color(0xff569B97), fontSize: 18),
                ),
                ),*/
                    Expanded(
                      flex: 2,
                      child: Slider(

                          min: 0,
                          max: speechController.duration.inMilliseconds
                              .toDouble(),
                          activeColor: buttonColor,
                          inactiveColor: borderColor,
                          value: speechController.position.inMilliseconds
                              .toDouble(),
                          onChanged: (value) async {
                            final position =
                                Duration(milliseconds: value.toInt());
                            await speechController.audioPlayer.seek(position);

                            await speechController.audioPlayer.resume();
                          }),
                    ),
                    Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              " ${speechController.formattedTime(timeInSecond: widget.note.speechDuration ?? 0)}",
                              style: TextStyle(color: buttonColor),
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            child: Icon(
                                speechController.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              size: 50,
                              ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5, left: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            timeago.format(widget.note.dateAdded),
                            style: TextStyleUtility.textStyleDate.copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                    /*Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                widget.onEdit();
                              },
                              icon: Icon(Icons.visibility),
                              color: Color(0xff717171)),
                          /*IconButton(onPressed: () {
                          onEdit();
                        }, icon: Icon(Icons.edit)),*/
                          IconButton(
                              onPressed: () {
                                print("on card delete pressed");
                                widget.onDelete();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Color(0xff717171),
                              )),
                        ],
                      ),
                    )*/
                  ],
                ),
              ),
            );
    });
  }
}
