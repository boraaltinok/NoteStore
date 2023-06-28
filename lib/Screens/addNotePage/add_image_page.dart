import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/PaddingUtility.dart';
import 'package:my_notes/controllers/note_controller.dart';
import 'package:my_notes/enums/noteActionEnums.dart';
import 'package:my_notes/enums/noteTypeEnums.dart';
import 'package:my_notes/widgets/addNotePagesAppBar.dart';
import '../../Models/Book.dart';
import 'add_note_page.dart';

import '../../lang/translation_keys.dart' as translation;
import 'package:my_notes/extensions/string_extension.dart';

class AddImagePage extends StatefulWidget {
  const AddImagePage({Key? key}) : super(key: key);

  @override
  State<AddImagePage> createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  bool textScanning = false;

  XFile? imageFile;
  CroppedFile? _croppedFile;

  String scannedText = "";

  final NoteController noteController = Get.put(NoteController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteController.initTextEditingControllers(noteAction: NoteAction.noteAdd);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Get.find<NoteController>().noteTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("kal");
    return Scaffold(
      backgroundColor: ColorsUtility.scaffoldBlackThemeBackgroundColor,
      appBar: AddNoteSheetsAppBar(
        noteTitleController: Get.find<NoteController>().noteTitleController,
        noteTypeEnum: NoteTypeEnum.imageNote,
        noteAction: NoteAction.noteAdd,
      ),
      body: Padding(
        padding: PaddingUtility.scaffoldBodyGeneralPadding,
        child: Center(
            child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (textScanning) const CircularProgressIndicator(),
              if (!textScanning && imageFile == null)
                Container(
                  width: MediaQuery.of(context).size.width * 6 / 10,
                  height: MediaQuery.of(context).size.height * 4 / 10,
                  color: Colors.grey[300]!,
                ),
              if (_croppedFile != null)
                SizedBox(
                    width: MediaQuery.of(context).size.width * 6 / 10,
                    height: MediaQuery.of(context).size.height * 4 / 10,
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.file(File(_croppedFile!.path))))
              else if (imageFile != null)
                SizedBox(
                    width: MediaQuery.of(context).size.width * 6 / 10,
                    height: MediaQuery.of(context).size.height * 4 / 10,
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.file(File(imageFile!.path)))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.grey,
                          shadowColor: Colors.grey[400],
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.image,
                                size: 30,
                              ),
                              Text(
                                translation.gallery.locale,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              )
                            ],
                          ),
                        ),
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.grey,
                          shadowColor: Colors.grey[400],
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        onPressed: () {
                          getImage(ImageSource.camera);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.camera_alt,
                                size: 30,
                              ),
                              Text(
                                translation.camera.locale,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              )
                            ],
                          ),
                        ),
                      )),
                  FloatingActionButton(
                    onPressed: () {
                      _cropImage();
                    },
                    backgroundColor: const Color(0xfffaf0e6),
                    foregroundColor: Colors.black,
                    tooltip: 'Crop',
                    child: const Icon(Icons.crop),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        )),
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        //textScanning = true;
        imageFile = pickedImage;
        noteController.setImagePath(pickedImage.path);

        setState(() {
          _croppedFile = null;
        });
        //getRecognisedText(pickedImage);
      }
    } catch (e) {
      //textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  /*void getRecognisedText(XFile? image) async {
    final inputImage = InputImage.fromFilePath(image!.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    RecognizedText recognisedText =
        await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;
    setState(() {});
  }*/

  Future<void> _cropImage() async {
    if (imageFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: translation.cropper.locale,
              toolbarColor: Color(0xfffaf0e6),
              toolbarWidgetColor: Colors.black,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: translation.cropper.locale,
          ),
          WebUiSettings(
            context: context,
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
        setState(() {
          _croppedFile = croppedFile;
        });

        noteController.setImagePath(croppedFile.path);
        //getRecognisedText(XFile(croppedFile.path));
      }
    } else {
      const snackBar = SnackBar(content: Text('Scan a text first to crop'));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
