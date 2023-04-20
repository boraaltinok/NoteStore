import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/PaddingUtility.dart';
import 'package:my_notes/Utils/TextStyleUtility.dart';
import 'package:my_notes/controllers/image_scan_controller.dart';
import 'package:my_notes/controllers/note_controller.dart';
import '../../Models/Book.dart';
import '../Screens/addNotePage/add_note_page.dart';
import '../enums/noteActionEnums.dart';
import '../enums/noteTypeEnums.dart';
import '../widgets/addNotePagesAppBar.dart';

class ImageToTextSheet extends StatefulWidget {
  final Book? book;

  const ImageToTextSheet(this.book, {Key? key}) : super(key: key);

  @override
  State<ImageToTextSheet> createState() => _ImageToTextSheetState();
}

class _ImageToTextSheetState extends State<ImageToTextSheet> {
  bool textScanning = false;

  XFile? imageFile;
  CroppedFile? _croppedFile;

  String scannedText = "";

  NoteController noteController = Get.put(NoteController());
  ImageScanController imageScanController = Get.put(ImageScanController());

  @override
  void initState() {
    print("inside init");
    super.initState();
    imageScanController.initImageScanVariables();
    noteController.initTextEditingControllers(noteAction: NoteAction.noteAdd);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    noteController.disposeTextEditingControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddNoteSheetsAppBar(
        noteTitleController: noteController.noteTitleController,
        noteTypeEnum: NoteTypeEnum.imageToTextNote,
        noteAction: NoteAction.noteAdd,
      ),
      body: Obx(() {
        return Padding(
          padding: PaddingUtility.scaffoldBodyGeneralPadding,
          child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (imageScanController.textScanning)
              const CircularProgressIndicator(
                color: Colors.black87,
              ),
            Container(
              width: MediaQuery.of(context).size.width * 7 / 10,
              height: MediaQuery.of(context).size.height * 3 / 10,
              color: Colors.grey[300]!,
              child: FittedBox(
                  clipBehavior: Clip.hardEdge,
                  fit: BoxFit.contain,
                  child: (!imageScanController.textScanning &&
                              imageScanController.imageFile == null) ||
                          imageScanController.imageFile?.path == ""
                      ? null
                      : (imageScanController.croppedFile != null && imageScanController.croppedFile?.path != ""
                          ? Image.file(
                              File(imageScanController.croppedFile!.path))
                          : (imageScanController.imageFile != null
                              ? Image.file(
                                  File(imageScanController.imageFile!.path))
                              : null))),
            ),
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
                        imageScanController.getImage(ImageSource.gallery);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.image,
                              size: 30,
                            ),
                            Text(
                              "Gallery",
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
                        imageScanController.getImage(ImageSource.camera);
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
                              "Camera",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600]),
                            )
                          ],
                        ),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      imageScanController.cropImage();
                    },
                    backgroundColor: const Color(0xfffaf0e6),
                    foregroundColor: Colors.black,
                    tooltip: 'Crop',
                    child: const Icon(Icons.crop),
                  ),
                )
              ],
            ),
            /*IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          //builder: (context) => AddNotePage(widget.bookId)));
                          builder: (context) => AddNotePage(
                                bookId: widget.bookId,
                                scannedText: scannedText,
                              )));
                },
                icon: const Icon(Icons.check),
              ),*/
            const SizedBox(
              height: 20,
            ),
            Text("Scanned Text", style: TextStyleUtility.headingTextStyle,),
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
            ),
            /*Text(
              imageScanController.scannedText ?? "",
              style: TextStyleUtility.textStyleBookInfoDialog,
            )*/
          ],
            ),
          ),
        );
      }),
    );
  }

/*void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {
          _croppedFile = null;
        });
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile? image) async {
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
  }



  Future<void> _cropImage() async {
    if (imageFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
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
        getRecognisedText(XFile(croppedFile.path));
      }
    } else {
      const snackBar = SnackBar(content: Text('Scan a text first to crop'));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }*/
}
