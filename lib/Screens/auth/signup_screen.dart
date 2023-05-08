import 'package:country_picker/country_picker.dart';
//import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/FontSizeUtility.dart';
import 'package:my_notes/Utils/PaddingUtility.dart';
import 'package:my_notes/extensions/string_extension.dart';
//import 'package:my_notes/extensions/string_extension.dart';
import 'package:my_notes/widgets/country_picker.dart';
import 'dart:io';
import '../../../constants.dart';
import '../../lang/locale_keys.g.dart';
import '../../widgets/gender_picker.dart';
import '../../widgets/text_input_field.dart';
import 'login_screen.dart';
import 'package:get/get.dart';
import '../../lang/translation_keys.dart' as translation;

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  late final TextEditingController _userNameController;

  late final TextEditingController _verifyPasswordController;



  String country = "";

  late String gender = "Male";

  String txtAppName = "NoteStore";

  String txtRegister = LocaleKeys.signUp_txt_signup;//"Register";

  String appName = translation.appName.locale;
  String register = translation.register.locale;
  String userName = translation.userName.locale;
  String email = translation.email.locale;
  String selectCountry = translation.selectCountry.locale;
  String male = translation.male.locale;
  String female = translation.female.locale;
  String intersex = translation.intersex.locale;
  String preferNotToState = translation.preferNotToState.locale;
  String password = translation.password.locale;
  String reEnterPassword = translation.reEnterPassword.locale;
  String registerUser = translation.registerUser.locale;
  String alreadyHaveAnAccount = translation.alreadyHaveAnAccount.locale;
  String login = translation.login.locale;


  @override
  void initState() {
    // TODO: implement initState
    authController.initializeProfilePhotoPath();
    //print(LocaleKeys.signUp_txt_signup.locale);
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _userNameController = TextEditingController();
    _verifyPasswordController = TextEditingController();
    gender = "Male";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(
      "device height ${Get.context!.height} ${Get.width} ${MediaQuery.of(context).size.height} ${MediaQuery.of(context).size.width}",
    );
    return Obx(() {
      return Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: Get.height,
            child: Padding(
              padding: PaddingUtility.scaffoldBodyGeneralPadding,
              child: authController.isRegisteringLoading? Lottie.asset('animations/book_page_gif.json', height: Get.height * 6 /10, reverse: true, repeat: true):Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: kToolbarHeight),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(appName,
                            style: TextStyle(
                                fontSize: FontSizeUtility.font35,
                                color: buttonColor,
                                fontWeight: FontWeight.w900)),
                        Text(
                          register,
                          style: TextStyle(
                              fontSize: FontSizeUtility.font25,
                              fontWeight: FontWeight.w900,
                              color: buttonColor),
                        ),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 66,
                              backgroundColor: ColorsUtility.blackText,
                              child: CircleAvatar(
                                radius: 64,
                                backgroundImage:
                                    //NetworkImage(authController.profilePhotoPath.value),
                                    authController.profilePhotoPath.value !=
                                            ""
                                        ? FileImage(File(authController.profilePhotoPath.value))
                                        : Image.asset('assets/logo.png').image,
                                backgroundColor: ColorsUtility.scaffoldBackgroundColor,
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
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextInputField(
                            controller: _userNameController,
                            labelText: userName,
                            icon: Icons.person,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextInputField(
                            controller: _emailController,
                            labelText: email,
                            icon: Icons.email,
                          ),
                        ),
                        /*CountryPicker(
                          onCountryChanged: (newCountry) {
                            country = newCountry;
                          },
                        ),*/
                        /*GenderPicker(onGenderChanged: (newGender) {
                          gender = newGender;
                        }),*/
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextInputField(
                            controller: _passwordController,
                            labelText: password,
                            icon: Icons.lock,
                            isObscure: true,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextInputField(
                            controller: _verifyPasswordController,
                            labelText: reEnterPassword,
                            icon: Icons.lock,
                            isObscure: true,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 40,
                          height: 50,
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: InkWell(
                            onTap: () {
                              authController.registerUser(
                                  _userNameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                  _verifyPasswordController.text,
                                  authController.profilePhoto,
                                  '',
                                  '');
                            },
                            child: Center(
                                child: Text(
                              registerUser,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            )),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              alreadyHaveAnAccount,
                              style:
                                  TextStyle(fontSize: 20, color: borderColor),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  login,
                                  style: TextStyle(
                                      fontSize: 20, color: buttonColor),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
