import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:my_notes/Utils/PaddingUtility.dart';
import 'package:my_notes/extensions/string_extension.dart';
import 'package:my_notes/widgets/country_picker.dart';
import 'dart:io';
import '../../../constants.dart';
import '../../lang/locale_keys.g.dart';
import '../../widgets/gender_picker.dart';
import '../../widgets/text_input_field.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _verifyPasswordController =
      TextEditingController();
  String country = "";
  String gender = "";


  String txtAppName = "NoteStore";
  String txtRegister = LocaleKeys.text1.locale;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: PaddingUtility.scaffoldBodyGeneralPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(txtAppName,
                    style: TextStyle(
                        fontSize: 35,
                        color: buttonColor,
                        fontWeight: FontWeight.w900)),
                Text(
                  txtRegister,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: buttonColor),
                ),
                const SizedBox(
                  height: 15,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 66,
                      backgroundColor: Colors.red,
                      child: CircleAvatar(
                        radius: 64,
                        backgroundImage:
                            //NetworkImage(authController.profilePhotoPath.value),
                            (authController.profilePhotoPath.value !=
                                    "https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png")
                                ? Image.file(File(authController
                                        .profilePhotoPath
                                        .toString()))
                                    .image
                                : Image.asset('assets/logo.png')
                                    .image,
                        backgroundColor: backgroundColor,
                      ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: () => authController.pickImage(),
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextInputField(
                    controller: _userNameController,
                    labelText: 'Username',
                    icon: Icons.person,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextInputField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CountryPicker(
                  onCountryChanged: (newCountry) {
                    country = newCountry;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                GenderPicker(onGenderChanged: (newGender) {
                  gender = newGender;
                }),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextInputField(
                    controller: _passwordController,
                    labelText: 'Password',
                    icon: Icons.lock,
                    isObscure: true,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextInputField(
                    controller: _verifyPasswordController,
                    labelText: 'Reenter Password',
                    icon: Icons.lock,
                    isObscure: true,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: InkWell(
                    onTap: () {
                      authController.registerUser(
                          _userNameController.text,
                          _emailController.text,
                          _passwordController.text,
                          authController.profilePhoto,
                          country.toString(),
                          gender.toString());
                    },
                    child: const Center(
                        child: Text(
                      "Register User",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 20, color: borderColor),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 20, color: buttonColor),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
