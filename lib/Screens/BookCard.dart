import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/Models/Book.dart';
import 'package:intl/intl.dart';

class BookCard extends StatefulWidget {
  final Book book;
  final Function onDelete;

  const BookCard({required this.book, required this.onDelete, Key? key})
      : super(key: key);

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff68c1bc),
      child: Container(
        constraints: BoxConstraints(minHeight: 80, maxHeight: 580),
        //height: 80,
        margin: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.book.bookName}",
                      maxLines: 3,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Color(0xff346e8c)),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${widget.book.bookAuthor}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),


                    ),
                    Text(DateFormat('yyyy-MM-dd – kk:mm')
                        .format(widget.book.dateAdded), style: TextStyle(color: Color(0xdd346e8c)),),
                  ],
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  widget.onDelete();
                },
                icon: const Icon(
                  Icons.delete,
                  color: Color(0xff346e8c),
                )),
          ],
        ),
      ),
    );
  }
}
