import 'package:flutter/material.dart';
import 'package:my_notes/constants.dart';

class GenderPicker extends StatefulWidget {
  final ValueChanged<String> onGenderChanged;

  const GenderPicker({Key? key, required this.onGenderChanged}) : super(key: key);

  @override
  _GenderPickerState createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  // Initial Selected Value
  String dropdownvalue = 'Male';

  // List of items in our dropdown menu
  var items = [
    'Male',
    'Female',
    'Intersex',
    'Prefer not to state',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton(
          // Initial Value
          value: dropdownvalue,
          dropdownColor: backgroundColor,

          // Down Arrow Icon
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: borderColor,
          ),

          // Array list of items
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item.toString(),
              child: Text(
                item,
                style: TextStyle(color: buttonColor,),
              ),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (String? newValue) {
            setState(() {
              widget.onGenderChanged(newValue!);
              dropdownvalue = newValue!;
            });
          },
        ),
      ],
    ));
  }
}
