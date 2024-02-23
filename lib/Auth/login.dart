import 'package:flutter/material.dart';
import 'package:shopperstore/Auth/forgotpassword.dart';
import 'package:shopperstore/Auth/signup.dart';
import 'package:shopperstore/homescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController emailcontroller = TextEditingController();
TextEditingController passwordcontroller = TextEditingController();
class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopperStore', style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Login', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                const SizedBox(height: 20,),
             TextFormField(
               controller: emailcontroller,
                decoration: InputDecoration(
                hintText: 'E-Mail',
                prefixIcon: const Icon(Icons.email),
                // suffixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30)
                )
              ),
             ),
                const SizedBox(height: 20,),
                TextFormField(
                  obscureText: true,
                  controller: passwordcontroller,
                  decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                    suffixIcon: const Icon(Icons.remove_red_eye),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)
                    )
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                    child: TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotScreen(),));
                    }, child: const Text('Forgot Password?'))),

                      SizedBox(
                        width: 120,
                        child: ElevatedButton(onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
                        }, style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan[300]),
                            child: const Text('Login', style: TextStyle(color: Colors.black),)),
                      ),
                  ],
                ),

                const SizedBox(height: 10,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   const Text("Don't have an account?"),

                    const SizedBox(width: 10,),

                    TextButton(onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                    }, child: const Text('SignUp'))
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
