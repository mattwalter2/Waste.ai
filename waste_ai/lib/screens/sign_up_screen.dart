// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:waste_ai/providers/app_provider.dart';

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final providerData = Provider.of<AppProvider>(context, listen: true);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign Up'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             TextField(
//               controller: _confirmPasswordController,
//               decoration: InputDecoration(labelText: 'Confirm Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   final credential = await FirebaseAuth.instance
//                       .createUserWithEmailAndPassword(
//                     email: _emailController.text,
//                     password: _passwordController.text,
//                   );
//                   providerData.setUserInfo(
//                       'Matthew',
//                       FirebaseAuth.instance.currentUser!.uid,
//                       'assets/SpottedLaternfly.jpeg');
//                   providerData.changeUserSignIn();
//                 } on FirebaseAuthException catch (e) {
//                   if (e.code == 'weak-password') {
//                     print('The password provided is too weak.');
//                   } else if (e.code == 'email-already-in-use') {
//                     print('The account already exists for that email.');
//                   }
//                 } catch (e) {
//                   print(e);
//                 }
//                 FirebaseAuth.instance.userChanges().listen((User? user) {
//                   if (user == null) {
//                     print('User is currently signed out!');
//                   } else {
//                     print('User is signed in!');
//                   }
//                 });
//               },
//               child: Text('Sign Up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
