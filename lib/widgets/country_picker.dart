import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/extensions/string_extension.dart';

import '../constants.dart';
import '../../lang/translation_keys.dart' as translation;

class CountryPicker extends StatefulWidget {
  final ValueChanged<String> onCountryChanged;

  CountryPicker({Key? key, required this.onCountryChanged}) : super(key: key);




  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  late String selectCountry;
  late String search;
  late String startTypingToSearch;


  @override
  void initState() {
    // TODO: implement initState
    selectCountry = translation.selectCountry.locale;
    search = translation.search.locale;
    startTypingToSearch = translation.startTypingToSearch.locale;
    super.initState();
  }
  String selectedCountry = "";
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(backgroundColor)),
        onPressed: () {
          showCountryPicker(
            context: context,

            //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
            exclude: <String>['KN', 'MF'],
            favorite: <String>['TR'],
            //Optional. Shows phone code before the country name.
            onSelect: (Country country) {
              print(country);
              widget.onCountryChanged(country.name);
              selectedCountry = country.name;
              setState(() {

              });
            },
            // Optional. Sets the theme for the country list picker.
            countryListTheme: CountryListThemeData(
              // Optional. Sets the border radius for the bottomsheet.
              textStyle: TextStyle(color: buttonColor),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
              backgroundColor: backgroundColor,
              // Optional. Styles the search field.
              inputDecoration: InputDecoration(
                filled: true,
                fillColor: buttonColor,
                labelText: search,
                labelStyle: const TextStyle(color: borderColor,),
                hintText: startTypingToSearch,
                hintStyle: const TextStyle(color: borderColor),
                prefixIcon: const Icon(Icons.search, color: borderColor,),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: buttonColor,
                  ),
                ),
              ),
              // Optional. Styles the text in the search field
              searchTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          );
        },
        child: Text(
          selectedCountry == "" ? selectCountry : selectedCountry,
          style: TextStyle(fontSize: 20, color: buttonColor),
        ),
      ),
    );
  }
}
