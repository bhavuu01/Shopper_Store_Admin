// import 'package:flutter/material.dart';
// import 'package:shopperstore/Auth/login.dart';
//
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});
//
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }
// TextEditingController nameController = TextEditingController();
// TextEditingController passwordController = TextEditingController();
// TextEditingController emailController = TextEditingController();
// TextEditingController confirmController = TextEditingController();
// class _SignupScreenState extends State<SignupScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SignUp',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),),
//         backgroundColor: Colors.cyan,
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             child: Column (
//               children: [
//                 const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Center(
//                     child: Text("Sign-Up", style: TextStyle(
//                             fontSize: 25, fontWeight: FontWeight.bold,color: Colors.black),),
//                   ),
//                 ),
//                 const SizedBox(height: 20,),
//                 TextFormField(
//                   controller: nameController,
//                   decoration: InputDecoration(
//                     suffixIcon: const Icon(Icons.person),
//                     hintText: "UserName",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30)
//                     ),
//                     focusedBorder: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30)),
//                       borderSide: BorderSide(color: Colors.black)
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20,),
//                 TextFormField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     suffixIcon: const Icon(Icons.email),
//                       hintText: "E-Mail",
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30)
//                       ),
//                     focusedBorder: const OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(30)),
//                         borderSide: BorderSide(color: Colors.black)
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20,),
//                 TextFormField(
//                   obscureText: true,
//                   controller: passwordController,
//                   decoration: InputDecoration(
//                     suffixIcon: const Icon(Icons.remove_red_eye),
//                       hintText: "Password",
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30)
//                       ),
//                     focusedBorder: const OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(30)),
//                         borderSide: BorderSide(color: Colors.black)
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20,),
//                 TextFormField(
//                   obscureText: true,
//                   controller: confirmController,
//                   decoration: InputDecoration(
//                     suffixIcon: const Icon(Icons.remove_red_eye),
//                       hintText: "Confirm Password",
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30)
//                       ),
//                     focusedBorder: const OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(30)),
//                         borderSide: BorderSide(color: Colors.black)
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20,),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: ElevatedButton(onPressed: (){
//
//                   }, style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
//                       child: const Text('Sign Up', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),)),
//                 ),
//                 const SizedBox(height: 20,),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Already have an account?', style: TextStyle(fontSize: 15),),
//                     TextButton(onPressed: (){
//                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
//                     }, child: const Text('Login'))
//                   ],
//                 ),
//
//               ],
//             )
//
//           ),
//         ),
//       ),
//     );
//   }
// }
