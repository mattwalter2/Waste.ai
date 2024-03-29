import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waste_ai/providers/app_provider.dart';
import 'package:waste_ai/screens/sign_up_1_screen.dart';
import 'package:waste_ai/screens/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<AppProvider>(context, listen: true);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text);
                  var currentUserInformation = await firestore
                      .collection("users")
                      .doc(auth.currentUser!.uid)
                      .get();

                  providerData.setUserInfo(
                      currentUserInformation.get('name'),
                      auth.currentUser!.uid,
                      currentUserInformation.get('profile_picture'),
                      currentUserInformation.get('level'),
                      currentUserInformation.get('experience'),
                      currentUserInformation.get('total_catches'),
                      currentUserInformation.get('badges'));

                  providerData.changeUserSignIn();
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  }
                }
                FirebaseAuth.instance.userChanges().listen((User? user) {
                  if (user == null) {
                    print('User is currently signed out!');
                  } else {
                    print('User is signed in!');
                  }
                });
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                providerData.changeSelectedIndex(1);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SignUp1Screen()),
                // );
              },
              child: Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
