
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../Models/Note.dart';

class SpeechController extends GetxController {
  /*final String tag;

  SpeechController(this.tag);*/
  final recorder = FlutterSoundRecorder();
  Rx<bool> _isRecorderReady = false.obs;
  final audioPlayer = AudioPlayer();
  Rx<bool> _isPlaying = false.obs;
  Rx<Duration> _duration = Duration.zero.obs;
  Rx<Duration> _position = Duration.zero.obs;
  Rx<bool> _isRecording = false.obs;

  final Rx<String> _noteId = Rx<String>("");

  bool get isRecorderReady => _isRecorderReady.value;
  bool get isPlaying => _isPlaying.value;
  bool get isRecording => _isRecording.value;



  //late Rx<Stream<RecordingDisposition>?> progress;
  Duration get duration => _duration.value;

  Duration get position => _position.value;

  updateNoteId(String noteId){
    _noteId.value = noteId;

  }


  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await recorder.openRecorder();
    _isRecorderReady.value = true;
    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );

    audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying.value = state == PlayerState.playing;
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      _duration.value = newDuration;
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      _position.value = newPosition;
    });

  }

  Future record() async {
    if (!_isRecorderReady.value) return;
    await recorder.startRecorder(toFile: 'audio');

    _isRecording.value = true;


  }

  Future stop() async {
    if (!_isRecorderReady.value) return;
    _isRecording.value = false;

    final path = await recorder.stopRecorder();
    final audioFile = File(path!);

    return path;
    print('recorder audio: $audioFile');
  }

  Future playAudio(String url) async {
    _isPlaying.value = true;
    await audioPlayer.play(UrlSource(url));
    audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying.value = false;
      _position.value = Duration.zero;
    });

  }

  Future pauseAudio() async {
    _isPlaying.value = false;

    await audioPlayer.pause();
  }
}
