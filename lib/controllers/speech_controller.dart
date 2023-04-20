import 'dart:async';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:my_notes/controllers/note_controller.dart';
import 'package:my_notes/enums/noteTypeEnums.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class SpeechController extends GetxController {
  late FlutterSoundRecorder recorder;
  late Rx<RecorderController> _recorderController;

  final Rx<bool> _isRecorderReady = false.obs;
  final audioPlayer = AudioPlayer();
  final Rx<bool> _isPlaying = false.obs;
  final Rx<Duration> _duration = Duration.zero.obs;
  final Rx<Duration> _position = Duration.zero.obs;
  final Rx<bool> _isRecording = false.obs;
  final Rx<bool> _isRecorderPaused = false.obs;
  final Rx<bool> _isRecorderControllerReady = false.obs;

  Duration finalNoteDuration = Duration.zero;
  final Rx<String> _noteId = Rx<String>("");

  bool get isRecorderReady => _isRecorderReady.value;

  bool get isRecorderControllerReady => _isRecorderControllerReady.value;

  bool get isPlaying => _isPlaying.value;

  bool get isRecording => _isRecording.value;

  bool get isRecorderPaused => _isRecorderPaused.value;
  late Rx<StreamSubscription<RecordingDisposition>?> progress =
      Rx<StreamSubscription<RecordingDisposition>?>(null);

  Duration get duration => _duration.value;

  Duration get position => _position.value;

  RecorderController get recorderController => _recorderController.value;

  updateNoteId(String noteId) {
    _noteId.value = noteId;
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    _isPlaying.value = false;
    _duration.value = Duration.zero;
    _position.value = Duration.zero;
    finalNoteDuration = Duration.zero;

    _isRecorderControllerReady.value = false;

    _isRecording.value = false;
    _isRecorderPaused.value = false;

    _isRecorderReady.value = false;

    recorder = FlutterSoundRecorder();
    _recorderController = RecorderController().obs;

    _isRecorderReady.value = true;
    _isRecorderControllerReady.value = true;

    await recorder.openRecorder();

    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
    audioPlayer.onDurationChanged.listen((newDuration) {
      _duration.value = newDuration;
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      _position.value = newPosition;
    });
  }

  Future disposeControllers() async {
    recorder.closeRecorder();
    audioPlayer.dispose();
    _recorderController.value.removeListener(() {});
    _recorderController.value.dispose();
    _isRecorderPaused.value = false;
    _isRecorderReady.value = false;
    _isRecorderControllerReady.value = false;
    _isPlaying.value = false;
    _isRecording.value = false;
  }

  Future record() async {
    if (!_isRecorderReady.value || !_isRecorderControllerReady.value) {
      return;
    }
    _recorderController.value.addListener(() {
      _duration.value = _recorderController.value.elapsedDuration;
    });
    progress.value = recorder.onProgress?.listen((e) {
      if (_isRecorderPaused.value == true) {
        progress.value!.cancel();
      }
    });

    await recorder.startRecorder(toFile: 'audio');
    await _recorderController.value.record();
    _isRecording.value = true;
  }

  Future resume() async {
    if (!_isRecorderReady.value || !_isRecorderControllerReady.value) return;

    await recorder.resumeRecorder();
    await _recorderController.value.record();

    _isRecording.value = true;
    _isRecorderPaused.value = false;
  }

  Future stop() async {
    if (!_isRecorderReady.value || !_isRecorderControllerReady.value) return;

    _isRecording.value = false;
    _isRecorderPaused.value = false;
    finalNoteDuration = duration;
    await _recorderController.value.stop();
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    return path;
  }

  Future pauseRecorder() async {
    print("1inside pauseRecorder $duration");

    if (!_isRecorderReady.value || !_isRecorderControllerReady.value) return;
    _isRecording.value = false;
    _isRecorderPaused.value = true;
    await _recorderController.value.pause();
    await recorder.pauseRecorder();
  }

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  Future playAudio(String url) async {
    _isPlaying.value = true;
    await audioPlayer.play(UrlSource(url));

    audioPlayer.onDurationChanged.listen((newDuration) {
      _duration.value = newDuration;
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      _position.value = newPosition;
    });
    audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying.value = false;
      _position.value = Duration.zero;
    });
  }

  Future pauseAudio() async {
    _isPlaying.value = false;
    await audioPlayer.pause();
  }

  Future onPressPlayAudioButton() async {
    if (isPlaying) {
      await pauseAudio();
    } else {
      await playAudio(Get.find<NoteController>().currentNote.speechPath!);
    }
  }

  Future onPressRecordButton() async {
    if (recorder.isRecording) {
      await pauseRecorder();
    } else {
      if (_isRecorderPaused.value == false) {
        await record();
      } else {
        await resume();
      }
    }
  }

  Future onSaveButtonPressed({String? noteTitle}) async {
    String path = await stop();
    String downloadUrl = await Get.find<NoteController>().uploadNote(
        noteTitle: noteTitle ?? "",
        speechPath: path,
        noteTypeEnum: NoteTypeEnum.speechNote,
        speechDuration: finalNoteDuration.inSeconds);
    Get.find<NoteController>().resetTextEditingControllers();
  }
}