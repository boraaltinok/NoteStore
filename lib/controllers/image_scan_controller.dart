
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_notes/controllers/note_controller.dart';

class ImageScanController extends GetxController {

  late Rx<bool> _textScanning;

  late Rx<XFile?> _imageFile;
  late Rx<CroppedFile?> _croppedFile;

  late Rx<String> _scannedText;

  bool get textScanning => _textScanning.value;
  CroppedFile? get croppedFile => _croppedFile.value;
  String? get scannedText => _scannedText.value;
  XFile? get imageFile => _imageFile.value;

  initImageScanVariables(){
    _imageFile = XFile("").obs;
    _croppedFile = CroppedFile("").obs;
    _textScanning = false.obs;
    _scannedText = "".obs;
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        _textScanning.value = true;
        print("heree ${_textScanning.value}");
        _imageFile.value = pickedImage;
          _croppedFile.value = null;

        getRecognisedText(pickedImage);
      }
    } catch (e) {
      _textScanning.value = false;
      _imageFile.value = null;
      _scannedText.value = "Error occured while scanning $e";
    }
  }

  void getRecognisedText(XFile? image) async {
    final inputImage = InputImage.fromFilePath(image!.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    RecognizedText recognisedText =
    await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    _scannedText.value = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        _scannedText.value = "${_scannedText.value}${line.text}\n";
      }
    }
    Get.find<NoteController>().noteTextEditingController.text = _scannedText.value;
    _textScanning.value = false;
  }

  Future<void> cropImage() async {
    if (_imageFile.value != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _imageFile.value!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Color(0xfffaf0e6),
              toolbarWidgetColor: Colors.black,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: Get.context!,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
            const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
          _croppedFile.value = croppedFile;

        //noteController.setImagePath(croppedFile.path);
        Get.find<NoteController>().setImagePath(croppedFile.path);

        getRecognisedText(XFile(croppedFile.path));
      }
    } else {
      const snackBar = SnackBar(content: Text('Scan a text first to crop'));

      //ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Get.snackbar("", "Scan a text first to crop");
    }
  }

}