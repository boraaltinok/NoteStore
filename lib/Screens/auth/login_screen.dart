import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:my_notes/Screens/auth/signup_screen.dart';
import 'package:my_notes/Utils/ColorsUtility.dart';
import 'package:my_notes/Utils/PaddingUtility.dart';
import 'package:my_notes/Utils/TextStyleUtility.dart';
import 'package:lottie/lottie.dart';

import '../../Utils/FontSizeUtility.dart';
import '../../Widgets/text_input_field.dart';
import '../../constants.dart';
import 'package:get/get.dart';
import '../../lang/translation_keys.dart' as translation;
import 'package:my_notes/extensions/string_extension.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  String appName = translation.appName.locale;
  String login = translation.login.locale;
  String email = translation.email.locale;
  String password = translation.password.locale;
  String register = translation.register.locale;
  String dontHaveAnAccount = translation.dontHaveAnAccount.locale;

  @override
  void initState() {
    // TODO: implement initState
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: Get.height,
            child: Padding(
              padding: PaddingUtility.scaffoldBodyGeneralPadding,
              child: authController.isLoggingLoading? Lottie.asset('animations/book_page_gif.json', height: Get.height * 6 / 10, reverse: true, repeat: true,):Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(flex: 2, child: SizedBox()),
                  Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(appName,
                              style: TextStyle(
                                  fontSize: FontSizeUtility.font35,
                                  color: buttonColor,
                                  fontWeight: FontWeight.w900)),
                          Text(
                            login,
                            style: TextStyle(
                                fontSize: FontSizeUtility.font25,
                                fontWeight: FontWeight.w900,
                                color: buttonColor),
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextInputField(
                              controller: _emailController,
                              labelText: email,
                              icon: Icons.email,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextInputField(
                              controller: _passwordController,
                              labelText: password,
                              icon: Icons.lock,
                              isObscure: true,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width -
                                FontSizeUtility.font40,
                            height: FontSizeUtility.font30 * 2,
                            decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                            child: InkWell(
                              onTap: () {
                                authController.loginUser(
                                    _emailController.text, _passwordController.text);
                              },
                              child: Center(
                                  child: Text(
                                    login,
                                    style: TextStyle(
                                        fontSize: FontSizeUtility.font20,
                                        fontWeight: FontWeight.w700),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: PaddingUtility.paddingTextLeftRight * 3,
                            child: Row(children: [
                              Expanded(child: Divider(color: ColorsUtility.hintTextColor, thickness: 2.00,)),
                              Text(translation.or.locale, style: TextStyleUtility.hintTextStyle,),
                              Expanded(child: Divider(color: ColorsUtility.hintTextColor, thickness: 2.00, )),
                            ]),
                          ),
                          Padding(
                            padding: PaddingUtility.paddingTextLeftRight * 3,
                            child: SizedBox(
                              height: FontSizeUtility.font30 * 2,
                              width: Get.width,
                              child: SignInButton(

                                Buttons.Google,
                                text: translation.signInWithGoogle.locale,
                                onPressed: () {
                                  authController.signInWithGoogle();
                                },
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dontHaveAnAccount,
                                style: TextStyle(
                                    fontSize: FontSizeUtility.font20,
                                    color: borderColor),
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => SignUpScreen()));
                                  },
                                  child: Text(
                                    register,
                                    style: TextStyle(
                                        fontSize: FontSizeUtility.font20,
                                        color: buttonColor),
                                  ))
                            ],
                          )
                        ],
                      )),
                  const Expanded(flex: 2, child: SizedBox()),
                ],
              ),
            ),
          ),
        ));
  }
}
