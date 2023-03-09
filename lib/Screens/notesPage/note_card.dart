import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/Databases/NotesDatabase.dart';
import 'package:my_notes/Models/Book.dart';
import 'package:intl/intl.dart';
import 'package:my_notes/constants.dart';

import '../../Models/Note.dart';
import '../../controllers/speech_controller.dart';
import 'package:get/get.dart';

final _lightColors = [
  /*Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100*/
  //Color(0xfffff0db),
  //Color(0xfffaf0e6),
  //Color(0xffeee9c4),
  //Color(0xffe4d4b7),
  Color(0xffD9D9D9)
];

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

  @override
  Widget build(BuildContext context) {
    SpeechController speechController =
        Get.put(SpeechController(), tag: widget.index.toString());
    speechController.initRecorder();

    final minHeight = getMinHeight(widget.index);

    final color = backgroundColor;//_lightColors[widget.index % _lightColors.length];

    return Obx(() {
      return Card(
        color: color,
        elevation: 8,
        child: Container(
          decoration: BoxDecoration(color: backgroundColor,),
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.2, maxHeight: MediaQuery.of(context).size.height * 0.25),
          //height: 80,
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(DateFormat('yyyy-MM-dd – kk:mm')
                        .format(widget.note.dateAdded), style: TextStyle(color: borderColor),),
                  ],
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
                flex: 1,
                child: Slider(
                    min: 0,
                    max: speechController.duration.inMilliseconds.toDouble(),
                    activeColor: buttonColor,
                    inactiveColor: borderColor,
                    value: speechController.position.inMilliseconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(milliseconds: value.toInt());
                      await speechController.audioPlayer.seek(position);

                      await speechController.audioPlayer.resume();
                    }),
              ),
              Expanded(flex:1, child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(" ${speechController.position.toString().substring(2,7)}", style: TextStyle(color: buttonColor),),

                ],
              )),

              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      child: IconButton(
                        icon: Icon(
                          speechController.isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        iconSize: 50,
                        onPressed: () async {
                          if (speechController.isPlaying) {
                            //await speechController.audioPlayer.pause();
                            print("durduruyorum");
                            print("here");
                            setState(() {
                              isPlaying = false;
                            });
                            await speechController.pauseAudio();
                          } else {
                            print("başlatıyorum");
                            print("here1");
                            setState(() {
                              isPlaying = true;
                            });
                            await speechController.playAudio(widget.note.speechPath!);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
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
              )
            ],
          ),
        ),
      );
    });
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    /*switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }*/
    return 100;
  }
}
