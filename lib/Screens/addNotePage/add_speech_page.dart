import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:my_notes/Utils/PaddingUtility.dart';
import 'package:my_notes/Utils/TextStyleUtility.dart';
import 'package:my_notes/Utils/TextUtility.dart';
import 'package:my_notes/controllers/speech_controller.dart';
import 'package:my_notes/enums/noteActionEnums.dart';
import 'package:my_notes/enums/noteTypeEnums.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'dart:ui' as ui show Gradient;
import '../../Utils/ColorsUtility.dart';
import '../../constants.dart';
import '../../controllers/note_controller.dart';
import '../../widgets/addNotePagesAppBar.dart';
import '../../widgets/custom_wave_forms_widget.dart';

class AddSpeechPage extends StatefulWidget {
  //final TextEditingController noteTitleController;

  const AddSpeechPage(
      {Key? key, required this.noteAction /*required this.noteTitleController*/
      })
      : super(key: key);

  final NoteAction noteAction;

  @override
  _AddSpeechPageState createState() => _AddSpeechPageState();
}

class _AddSpeechPageState extends State<AddSpeechPage> {
  NoteController noteController = Get.find<NoteController>();
  final SpeechController speechController = Get.put(SpeechController());
  final loadingText = TextUtility.loadingText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.noteAction == NoteAction.noteEdit) {
      noteController.initTextEditingControllers(
          noteAction: widget.noteAction, note: noteController.currentNote);
    } else if (widget.noteAction == NoteAction.noteAdd) {
      noteController.initTextEditingControllers(noteAction: widget.noteAction);
    }
    Future.delayed(Duration.zero, () async {
      await speechController.initRecorder();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    noteController.disposeTextEditingControllers();
    speechController.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAddNoteSheetsAppBar(),
      body: Padding(
          padding: PaddingUtility.scaffoldBodyGeneralPadding,
          child: Obx(() {
            return buildCenteredColumn();
          })),
      floatingActionButton: FloatingActionButton(
        child: Obx(() {
          if (NoteAction.noteAdd == widget.noteAction) {
            return Icon(speechController.isRecording ? Icons.stop : Icons.mic);
          } else {
            return Icon(speechController.isPlaying
                ? Icons.pause_circle_outline
                : Icons.play_arrow_outlined);
          }
        }),
        onPressed: () async {
          if (NoteAction.noteAdd == widget.noteAction) {
            await speechController.onPressRecordButton();
          } else {
            await speechController.onPressPlayAudioButton();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Center buildCenteredColumn() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Expanded(flex: 1, child: durationText()),
          widget.noteAction == NoteAction.noteAdd
              ? Expanded(
            flex: 5,
            child: speechController.isRecorderControllerReady == true
                ? CustomWaveformsWidget(
                speechController: speechController)
                : buildCenteredLoadingText(),
          )
              : Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(child: Text(speechController.formattedTime(
                      timeInSecond: speechController.position.inSeconds),
                    style: TextStyleUtility.hintTextStyle,)),
                  Expanded(
                    flex: 6,
                    child: Slider(
                        min: 0,
                        max: speechController.duration.inMilliseconds
                            .toDouble(),
                        activeColor: buttonColor,
                        inactiveColor: borderColor,
                        value:
                        speechController.position.inMilliseconds.toDouble(),
                        onChanged: (value) async {
                          final position = Duration(
                              milliseconds: value.toInt());
                          await speechController.audioPlayer.seek(position);

                          await speechController.audioPlayer.resume();
                        }),
                  ),
                  Expanded(child: Text(speechController.formattedTime(
                      timeInSecond: noteController.currentNote.speechDuration ??
                          speechController.duration.inSeconds),
                    style: TextStyleUtility.hintTextStyle,)),

                ],
              )),
          Expanded(flex: 1, child: SizedBox())
        ],
      ),
    );
  }

  AddNoteSheetsAppBar buildAddNoteSheetsAppBar() {
    return AddNoteSheetsAppBar(
      noteTitleController: noteController.noteTitleController,
      noteAction: widget.noteAction,
      noteTypeEnum:
      NoteTypeEnum.speechNote, /*speechController: speechController*/
    );
  }

  Center buildCenteredLoadingText() {
    return Center(
      child: Text(loadingText),
    );
  }

  Text durationText() {
    /*'${(speechController.duration.inSeconds~/60)}:${speechController.duration.inSeconds % 60}s',
      style: TextStyle(fontSize: 30, color: ColorsUtility.blackText),*/
    return Text(
      widget.noteAction == NoteAction.noteAdd
          ? '${speechController.duration.inSeconds}s'
          : '${speechController.position.inSeconds}:${speechController.duration
          .inSeconds}s',
      style: TextStyle(fontSize: 30, color: ColorsUtility.blackText),
    );
  }
}
