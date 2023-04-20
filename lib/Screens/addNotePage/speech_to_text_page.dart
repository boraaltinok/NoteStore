import 'package:flutter/cupertino.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:my_notes/Screens/addNotePage/add_note_page.dart';
import 'package:my_notes/Screens/bookPage/books_page.dart';
import 'package:my_notes/Screens/notesPage/notes_page.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../Models/Book.dart';

class SpeechToTextScreen extends StatefulWidget {
  final Book? book;
  bool isListening;

  SpeechToTextScreen({required this.book, this.isListening =false ,Key? key}) : super(key: key);



  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  late stt.SpeechToText _speech;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    //_isListening = false;

    _speech = stt.SpeechToText();
    print('inside init State isListening value = ${widget.isListening}');
  }

  @override
  void dispose() {
    // TODO: implement dispose

    print('dispose islistening: ${widget.isListening}');
    super.dispose();
    _speech.stop();
    _speech.cancel();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      print("set state called with mounting");
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfffaf0e6),
          automaticallyImplyLeading: false,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%',
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  /*Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddNotePage(
                                bookId: widget.bookId,
                                spokenText: _text ==
                                        "Press the button and start speaking"
                                    ? ""
                                    : _text,
                              )));*/
                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          //builder: (context) => AddNotePage(widget.bookId)));
                          builder: (context) => AddNotePage(
                                book: widget.book,
                                spokenText: _text ==
                                        "Press the button and start speaking"
                                    ? ""
                                    : _text,
                              )));*/
                },
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.black,
                ))
          ],
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        //builder: (context) => AddNotePage(widget.bookId)));
                        builder: (context) => NotesPage(widget.book!)));
              },
              icon: const Icon(Icons.arrow_circle_left, color: Colors.black)),
        ),
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
              print("listen called");
            },
            child: Icon(widget.isListening ? Icons.mic : Icons.mic_none,),
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
            padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
            child: TextHighlight(
              text: _text,
              words: _highlights,
              textStyle: const TextStyle(
                fontSize: 32.0,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _listen() async {
    print("called");
    if (!widget.isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          setState(() {
            print("inside set state");
            if (val == "notListening") {
              print("val = not listening");
              widget.isListening = false;
              print('is listening changed state to ${widget.isListening}');
            } else if (val == 'done') {
              print("val = done");
              widget.isListening = false;
              print('is listening changed state to ${widget.isListening}');
              _speech.cancel();

            }
          });
        },
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        print("listening atm");

        setState(() => widget.isListening = true);

        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      print("in else to speech stop");
      setState(() => widget.isListening = false);

      _speech.stop();
    }
  }

  updateIsListeningFunction(String val) async {
    print("beginning updateIsListeningFunction");
    if (this.mounted) {
      setState(() {
        print("inside onStatus setState");
        if (val == "notListening" || val == "done") {
          widget.isListening = false;
          _speech.stop();
          print("not listening or done");
        } else {
          print("Listening");

          widget.isListening = true;
        }
      });
    } else {
      print("not mounted");
    }
    print("end updateIsListeningFunction");
  }
}
