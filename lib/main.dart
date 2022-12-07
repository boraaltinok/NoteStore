import 'dart:io';

import 'package:flutter/material.dart';

import 'package:my_notes/Screens/books_page.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  //0xff3EC4BD AÇIK MAVI
  //#00386B KOYU MAVI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        fontFamily: GoogleFonts.kalam().fontFamily,
        accentColor: const Color(0xff00386B),
      ),
      //home: const MyHomePage(),
      //home: const BookNotes(),
      home: const BooksPage(),// bunla çalıştıırcan
      //home: const ScanBookPage(),
    );
  }
}

