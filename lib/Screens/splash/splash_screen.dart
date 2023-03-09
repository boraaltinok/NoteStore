import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/Screens/auth/signup_screen.dart';
import 'package:get/get.dart';
import 'package:my_notes/constants.dart';

import '../bookPage/books_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat(reverse: false);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), (){
      if(firebaseAuth.currentUser == null){
        Get.offAll(() => SignUpScreen());
      }else{
        Get.offAll(() => const BooksPage());
        //Get.offAll(() => SignUpScreen());

      }
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) =>  SignUpScreen())));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 130,),
              const SizedBox(height: 30,),
              const CircularProgressIndicator(
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
