import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:my_notes/controllers/speech_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/note_controller.dart';

class AddSpeechPage extends StatefulWidget {
  const AddSpeechPage({Key? key}) : super(key: key);

  @override
  _AddSpeechPageState createState() => _AddSpeechPageState();
}

class _AddSpeechPageState extends State<AddSpeechPage> {
  /*final recorder = FlutterSoundRecorder();

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  bool isRecorderReady = false;*/

  NoteController noteController = Get.put(NoteController());
  SpeechController speechController = Get.put(SpeechController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    speechController.initRecorder();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    speechController.recorder.closeRecorder();
    speechController.audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return Scaffold(
          backgroundColor: Colors.grey.shade900,
          body: Center(
            child: speechController.isRecorderReady == false ? Center(child: Text("loading")) :Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<RecordingDisposition>(
                  stream: speechController.recorder.onProgress,
                  builder: (context, snapshot) {
                    final duration =
                        snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                    print("snapshot = $snapshot");

                    print("again duration = $duration");

                    String twoDigits(int n) => n.toString().padLeft(0);
                    final twoDigitMinutes =
                        twoDigits(duration.inMinutes.remainder(60));

                    final twoDigitSeconds =
                        twoDigits(duration.inSeconds.remainder(60));
                    /*return Text(
                      '$twoDigitMinutes:$twoDigitSeconds',
                      style: const TextStyle(
                          fontSize: 80, fontWeight: FontWeight.bold),
                    );*/
                    return Text('${duration.inSeconds}s');
                  },
                ),
                const SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                  child: Icon(speechController.isRecording ? Icons.stop : Icons.mic),
                  onPressed: () async {
                    if (speechController.recorder.isRecording) {
                      String path = await speechController.stop();
                      String randomId = const Uuid().v4();

                      /*String downloadUrl = await noteController
                          .uploadSpeechNoteToStorage(randomId, path);*/
                      String downloadUrl = await noteController.uploadNote(bookId: noteController.bookId, noteText: "here", speechPath: path, noteType: "speech");
                      //print("uploaded $downloadUrl");
                      if (speechController.isPlaying) {
                        await speechController.audioPlayer.pause();
                      } else {
                        print("playingg");
                        /*await speechController.audioPlayer.play(UrlSource(
                          "$downloadUrl"
                        ));*/
                      }
                      Get.back();

                    } else {
                      await speechController.record();
                    }
                  },
                ),
                /*ElevatedButton(
                  child: Icon(speechController.isPlaying ? Icons.stop : Icons.mic),
                  onPressed: () async {
                    if (speechController.isPlaying) {
                      await speechController.audioPlayer.pause();
                    } else {
                      print("playingg");
                      await speechController.audioPlayer.play(UrlSource(
                        "https://firebasestorage.googleapis.com/v0/b/notestore-eea0e.appspot.com/o/speechNotes%2F18e9a27d-65f1-4a9d-88b9-0510dbb4151b?alt=media&token=24fe4968-d1b2-45d8-8da1-67122e74a805"
                      ));
                    }
                  },
                ),*/
              ],
            ),
          ),
        );
      }
    );
  }
}
