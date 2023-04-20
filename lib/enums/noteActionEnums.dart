import 'package:flutter/material.dart';

import '../Utils/ColorsUtility.dart';

enum NoteAction {
  noteEdit,
  noteAdd,
}

extension NoteActionExtension on NoteAction {
  Icon returnNoteActionIcon() {
    switch (this) {
      case NoteAction.noteAdd:
        return Icon(
          Icons.check_circle_outline,
          color: ColorsUtility.appBarIconColor,
        );
      case NoteAction.noteEdit:
        return Icon(
          Icons.edit,
          color: ColorsUtility.appBarIconColor,
        );
    }
  }

  Text returnNoteActionIconLabel() {
    switch (this) {
      case NoteAction.noteAdd:
        return  Text(
          "Save",
          style: TextStyle(color: ColorsUtility.blackText),
        );
      case NoteAction.noteEdit:
        return  Text(
          "Edit",
          style: TextStyle(color: ColorsUtility.blackText),
        );
    }
  }
}
