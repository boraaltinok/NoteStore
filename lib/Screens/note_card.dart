import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/Databases/NotesDatabase.dart';
import 'package:my_notes/Models/Book.dart';
import 'package:intl/intl.dart';

import '../Models/Note.dart';

final _lightColors = [
  /*Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100*/
  //Color(0xfffff0db),
  //Color(0xfffaf0e6),
  //Color(0xffeee9c4),
  //Color(0xffe4d4b7),
  Color(0xffD9D9D9)
];

class NoteCard extends StatelessWidget {
  final Note note;
  final int index;
  final Function onDelete;
  final Function onView;
  final Function onEdit;

  const NoteCard(
      {required this.note,
      required this.index,
      required this.onDelete,
      required this.onView,
      required this.onEdit,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minHeight = getMinHeight(index);

    final color = _lightColors[index % _lightColors.length];

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight, maxHeight: 200),
        //height: 80,
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(DateFormat('yyyy-MM-dd – kk:mm').format(note.dateAdded)),
              ],
            ),
            Text(
              "${note.noteTitle}".toUpperCase(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Color(0xff00386B)),
            ),
            //Text(DateFormat('yyyy-MM-dd – kk:mm').format(note.dateAdded)),
            Text(
              note.noteText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Color(0xff569B97), fontSize: 18),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      onEdit();
                    },
                    icon: Icon(Icons.visibility),
                    color: Color(0xff717171)),
                /*IconButton(onPressed: () {
                    onEdit();
                  }, icon: Icon(Icons.edit)),*/
                IconButton(
                    onPressed: () {
                      print("on card delete pressed");
                      onDelete();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Color(0xff717171),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    /*switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }*/
    return 100;
  }
}
