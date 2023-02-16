import 'package:mobilekyc/screens/changePassword/provider/changeProvider.dart';
import 'package:mobilekyc/screens/changePassword/view/changePasswordPage.dart';
import 'package:mobilekyc/screens/intro/provider/introProvider.dart';
import 'package:mobilekyc/screens/intro/view/introPage.dart';
import 'package:mobilekyc/screens/login/provider/loginProvider.dart';
import 'package:mobilekyc/screens/login/view/loginPage.dart';
import 'package:mobilekyc/screens/registration/provider/registrationProvider.dart';
import 'package:mobilekyc/screens/registration/view/registrationPage.dart';
import 'package:mobilekyc/screens/splash/view/splashPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => IntroProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RegistrationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChangePasswordProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
      ),
    ),
  );
}
