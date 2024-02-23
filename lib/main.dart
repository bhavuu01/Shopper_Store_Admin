import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopperstore/Auth/forgotpassword.dart';
import 'package:shopperstore/Auth/login.dart';
import 'package:shopperstore/Auth/signup.dart';
import 'package:shopperstore/Category/addcategory.dart';
import 'package:shopperstore/Category/categorymodel.dart';
import 'package:shopperstore/homescreen.dart';
import 'package:shopperstore/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),

    );
  }
}
