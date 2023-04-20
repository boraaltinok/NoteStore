import 'package:flutter/material.dart';
import 'dart:ui' as ui show Gradient;
import '../Utils/ColorsUtility.dart';
import '../controllers/speech_controller.dart';
import 'package:audio_waveforms/audio_waveforms.dart';


class CustomWaveformsWidget extends StatelessWidget {
  const CustomWaveformsWidget({
    Key? key,
    required this.speechController,
  }) : super(key: key);

  final SpeechController speechController;

  @override
  Widget build(BuildContext context) {
    return AudioWaveforms(
      size: Size(
          MediaQuery.of(context).size.width, 400.0),
      backgroundColor: ColorsUtility.blackText ?? Colors.black87,

      recorderController:
      speechController.recorderController,
      enableGesture: false,
      //decoration: BoxDecoration(color: ColorsUtility.blackText),
      waveStyle: WaveStyle(
        extendWaveform: true,
        durationLinesHeight: 36.0,
        waveThickness: 9.0,
        spacing: 12.0,
        scaleFactor: 250.0,
        showMiddleLine: false,
        gradient: ui.Gradient.linear(
          const Offset(70, 50),
          Offset(
              MediaQuery.of(context).size.width / 2,
              0),
          [
            ColorsUtility.gradientColor1 ??
                Colors.red,
            ColorsUtility.gradientColor2 ??
                Colors.green
          ],
        ),
      ),
    );
  }
}