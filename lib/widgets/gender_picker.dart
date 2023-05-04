import 'package:flutter/material.dart';
import 'package:my_notes/constants.dart';
import '../../lang/translation_keys.dart' as translation;
import 'package:my_notes/extensions/string_extension.dart';

import '../enums/genderTypeEnums.dart';

class GenderPicker extends StatefulWidget {
  final ValueChanged<String> onGenderChanged;

  const GenderPicker({Key? key, required this.onGenderChanged}) : super(key: key);

  @override
  _GenderPickerState createState() => _GenderPickerState();
}

class _GenderPickerState extends State<GenderPicker> {
  // Initial Selected Value
  String dropdownvalue = translation.male.locale;

  // List of items in our dropdown menu
  var items = [
    translation.male.locale,
    translation.female.locale,
    translation.intersex.locale,
    translation.preferNotToState.locale,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      Expanded(
        child: DropdownButton(
          // Initial Value
          value: dropdownvalue,
          dropdownColor: backgroundColor,
          isExpanded: true,
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
            if(newValue == translation.male.locale){
              newValue = GenderType.male.returnGenderTypeNumber().toString();
            }else if(newValue == translation.female.locale){
              newValue = GenderType.female.returnGenderTypeNumber().toString();
            }else if(newValue == translation.intersex.locale){
              newValue = GenderType.intersex.returnGenderTypeNumber().toString();
            }else if(newValue == translation.preferNotToState.locale){
              newValue = GenderType.preferNotToState.returnGenderTypeNumber().toString();
            }
            setState(() {
              widget.onGenderChanged(newValue!);
              dropdownvalue = newValue!;
            });
          },
        ),
      ),
        ],
      ),
    );
  }
}
