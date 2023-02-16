import 'dart:async';

import 'package:mobilekyc/screens/home/view/homePage.dart';
import 'package:mobilekyc/screens/intro/provider/introProvider.dart';
import 'package:mobilekyc/screens/intro/view/introPage.dart';
import 'package:mobilekyc/screens/login/view/loginPage.dart';
import 'package:mobilekyc/screens/registration/view/registrationPage.dart';
import 'package:mobilekyc/utility/constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:mobilekyc/utility/sharePreference.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  IntroProvider? providerTrue;
  IntroProvider? providerFalse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      Duration(seconds: 5),
      () async {
        bool? check = await providerTrue!.readIntroPageShar();

        bool? checkLogin = await loginCheck();

        // Future<bool?> check = Provider.of<IntroProvider>(context, listen: true)
        //     .readIntroPageShar();
        if (check == true) {
          if (checkLogin == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IntroPage(),
            ),
          );
        }

        // if (check == false) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => IntroPage(),
        //     ),
        //   );
        // } else {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => LoginPage(),
        //     ),
        //   );
        // }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    providerTrue = Provider.of<IntroProvider>(context, listen: true);
    providerFalse = Provider.of<IntroProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Style.white,
        body: Center(
          child: Lottie.asset(
            'assets/animation/4.json',
            repeat: true,
            reverse: false,
          ),
        ),
      ),
    );
  }
}
