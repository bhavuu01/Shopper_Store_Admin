import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopperstore/Auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.cyan, Colors.redAccent],
          begin: Alignment.topRight,
            end: Alignment.bottomLeft
          )
        ),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Image.asset('asset/images/shopping.png', height: 200.0, width: 200.0,),
           const SizedBox(height: 10,),
           const Text(
                'ShopperStore',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
              ),
           const SizedBox(height: 20,),
           const CircularProgressIndicator(color: Colors.white),
         ],
       ),
      ),
    );
  }
}
