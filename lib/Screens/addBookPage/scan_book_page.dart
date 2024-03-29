import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:my_notes/Screens/bookPage/books_page.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/constants.dart';
import 'package:my_notes/controllers/book_controller.dart';
import 'package:my_notes/extensions/string_extension.dart';
import '../../Secrets/api_keys.dart';
import 'package:get/get.dart';
import '../../Models/Book.dart';
import '../../lang/translation_keys.dart' as translation;

class ScanBookPage extends StatefulWidget {
  const ScanBookPage({Key? key}) : super(key: key);

  @override
  _ScanBookPageState createState() => _ScanBookPageState();
}

class _ScanBookPageState extends State<ScanBookPage> {
  late MobileScannerController cameraController;
  bool _screenOpened = false;
  late bool _isBookAdded;
  BookController bookController = Get.put(BookController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cameraController = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates, autoStart: true);
    cameraController.stop(); //to avoid reopening bug
    _isBookAdded = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    cameraController.stop();
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: ColorsUtility.appBarIconColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: FittedBox(
          fit: BoxFit.cover,
          child: Text(
            translation.scanISBNBarcode.locale,
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return Icon(
                      Icons.flash_off,
                      color: ColorsUtility.hintTextColor,
                    );
                  case TorchState.on:
                    return Icon(
                      Icons.flash_on,
                      color: ColorsUtility.appBarIconColor,
                    );
                }
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
            iconSize: 32,
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return Icon(
                      Icons.camera_front,
                      color: ColorsUtility.hintTextColor,
                    );
                  case CameraFacing.back:
                    return Icon(
                      Icons.camera_rear,
                      color: ColorsUtility.appBarIconColor,
                    );
                }
              },
            ),
            onPressed: () => cameraController.switchCamera(),
            iconSize: 32,
          ),
        ],
      ),
      body: MobileScanner(
        //allowDuplicates: true,
        controller: cameraController,
        onDetect: _foundBarcode,
      ),
    );
  }

  Future<void> _foundBarcode(BarcodeCapture barcode) async {
    ///open screen
    if (!_screenOpened) {
      final String code = barcode.barcodes[0].rawValue ?? "----";
      debugPrint('Barcode found $code');
      _screenOpened = true;
      fetchBooksInfo(code);
    }
  }

  void fetchBooksInfo(String code) async {
    String result = "";
    var response;
    try {
      response = await Dio().get('https://api2.isbndb.com/book/$code',
          options: Options(
            headers: {"Authorization": ISBN_API_KEY},
          ));
      if (response.statusCode == 200) {
        print("I AM 200 success");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        var snackBar =
            SnackBar(content: Text('This is not a valid ISBN barcode $code'));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print(e.response?.statusCode);
      }
    }
    late Book scannedBook;
    var scannedBookInfo;
    if (response != null) {
      scannedBookInfo = response.data; // this is a map
    }
    if (scannedBookInfo != null) {
      scannedBook = Book(
          bookName: scannedBookInfo['book']['title'],
          bookAuthor: scannedBookInfo['book']['authors'][0],
          dateAdded: DateTime.now(),
          userId: authController.user.uid,
          bookCover: scannedBookInfo['book']['image']);
      print(scannedBookInfo['book']['image']);
      //await bookController.uploadBookCoverToStorage(authController.user.uid, scannedBookInfo['book']['image']);
      await bookController.uploadBook(
          bookName: scannedBookInfo['book']['title'],
          bookAuthor: scannedBookInfo['book']['authors'][0],
          isItScan: true,
          bookCoverPath: scannedBookInfo['book']['image']);
      //NotesDatabase.instance.createBook(scannedBook);
      setState(() {
        _isBookAdded = true;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BooksPage()));
      });
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const BooksPage()));

    //return scannedBook;
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }
}

class FoundCodeScreen extends StatefulWidget {
  final String value;
  final Function() screenClosed;

  const FoundCodeScreen(
      {Key? key, required this.value, required this.screenClosed})
      : super(key: key);

  @override
  _FoundCodeScreenState createState() => _FoundCodeScreenState();
}

class _FoundCodeScreenState extends State<FoundCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Found Code"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            widget.screenClosed();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Scanned Code",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.value,
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
