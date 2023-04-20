import 'package:flutter/cupertino.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/controllers/note_controller.dart';
import 'package:my_notes/enums/noteActionEnums.dart';
import 'package:my_notes/enums/noteTypeEnums.dart';
import 'package:my_notes/widgets/addNotePagesAppBar.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:get/get.dart';
import '../../Models/Book.dart';
import '../Utils/ColorsUtility.dart';

class SpeechToTextSheet extends StatefulWidget {
  final Book? book;
  bool isListening;

  SpeechToTextSheet({required this.book, this.isListening =false ,Key? key}) : super(key: key);



  @override
  State<SpeechToTextSheet> createState() => _SpeechToTextSheetState();
}

class _SpeechToTextSheetState extends State<SpeechToTextSheet> {

  late stt.SpeechToText _speech;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  NoteController noteController = Get.put(NoteController());


  @override
  void initState() {
    super.initState();
    noteController.initTextEditingControllers(noteAction: NoteAction.noteAdd);

    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    noteController.disposeTextEditingControllers();
    super.dispose();
    _speech.stop();
    _speech.cancel();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AddNoteSheetsAppBar(noteTitleController: noteController.noteTitleController, noteTypeEnum: NoteTypeEnum.speechToTextNote, noteAction: NoteAction.noteAdd,),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: widget.isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75.0,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () async {
              await _listen();
            },
            child: Icon(widget.isListening ? Icons.mic : Icons.mic_none,),
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
            padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
            child:
            TextField(
              controller:
              Get.find<NoteController>().noteTextEditingController,
              keyboardType: TextInputType.multiline,
              //maxLines: 10,
              minLines: 3,
              maxLines: null,
              decoration: InputDecoration(
                  hintText: "Write and Edit your note here",
                  hintStyle: TextStyle(color: ColorsUtility.hintTextColor),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorsUtility.blackText ?? Colors.black87)),
                  border: OutlineInputBorder(borderSide: BorderSide(color: ColorsUtility.blackText ?? Colors.black87))),
              style: TextStyle(color: ColorsUtility.blackText),
            )/*TextHighlight(
              text: _text,
              words: _highlights,
              textStyle: const TextStyle(
                fontSize: 32.0,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            )*/,
          ),
        ),
      ),
    );
  }

  _listen() async {
    if (!widget.isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          setState(() {
            if (val == "notListening") {
              widget.isListening = false;
            } else if (val == 'done') {
              widget.isListening = false;
              _speech.cancel();
            }
          });
        },
        onError: (val) {},
      );
      if (available) {

        setState(() => widget.isListening = true);

        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            noteController.noteTextEditingController.text =  _text;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => widget.isListening = false);

      _speech.stop();
    }
  }

  updateIsListeningFunction(String val) async {
    if (mounted) {
      setState(() {
        if (val == "notListening" || val == "done") {
          widget.isListening = false;
          _speech.stop();
        } else {

          widget.isListening = true;
        }
      });
    } else {
    }
  }
}
