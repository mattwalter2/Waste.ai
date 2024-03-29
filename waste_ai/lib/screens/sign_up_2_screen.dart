import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waste_ai/providers/app_provider.dart';

// Import Cupertino for iOS style widgets

import 'package:firebase_auth/firebase_auth.dart';

class SignUp2Screen extends StatefulWidget {
  final VoidCallback? checkUserSignedIn;
  const SignUp2Screen({super.key, this.checkUserSignedIn});

  @override
  State<SignUp2Screen> createState() => _SignUp2ScreenState();
}

class _SignUp2ScreenState extends State<SignUp2Screen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<dynamic> checkpassword(password) {
    if (password.length < 8) {
      return [false, "The password is too short", Colors.red]; // Too short
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'\d'));
    bool hasSpecialCharacter =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (hasUppercase == false) {
      return [
        false,
        "The password should have an uppercase character",
        Colors.red
      ];
    } else if (hasLowercase == false) {
      return [
        false,
        "The password should have a lowercase character",
        Colors.red
      ];
    } else if (hasDigit == false) {
      return [false, "The password should have a numeric", Colors.red];
    } else if (hasSpecialCharacter == false) {
      return [false, "The password should have a symbol", Colors.red];
    } else {
      return [true, "The password is okay", Colors.green];
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<AppProvider>(context, listen: true);
    String? _errorMessage;
    List x = [false, "The password is too short", Colors.red];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Color.fromRGBO(86, 3, 173, 1),
          // Back button with custom color
          onPressed: () {
            providerData.changeSelectedIndex(1);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Removes the shadow under the app bar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Row(children: [
              //   Image.asset('assets/marble_logo.png', width: 100, height: 100),
              //   ChatBubble(
              //       text: "${providerData.name}, let's make you an account"),
              // ]),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'e-mail',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter email";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter password";
                  } else {
                    List result = checkpassword(value);
                    if (result[0] == false) {
                      return result[1];
                    }
                  }
                },
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'password',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 32),
              SizedBox(
                width:
                    double.infinity, // Ensure the buttons stretch to full width
                child: ElevatedButton(
                  child: Text('Continue'),
                  onPressed: () async {
                    _formKey.currentState!.validate();
                    if (checkpassword(_passwordController.text)[0] == true) {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      providerData.updateEmail(email);
                      providerData.updatePassword(password);
                      try {
                        await auth.createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        providerData.setUserInfo(
                            providerData.name,
                            auth.currentUser!.uid,
                            providerData.profilePictureUrl,
                            1,
                            0,
                            0, []);

                        // Reference to the users collection
                        CollectionReference currentUser =
                            firestore.collection('users');

// Add a new document with a generated ID

// Specify the document ID and set the data
                        currentUser.doc(auth.currentUser!.uid).set({
                          'name': providerData.name,
                          'profile_picture': providerData.profilePictureUrl,
                          'email': _emailController.text,
                          'password': _passwordController.text,
                          'level': 1,
                          'experience': 0,
                          'badges': []
                        });

                        providerData.changeUserSignIn();
                        providerData.changeSelectedIndex(0);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                    // awsAuth.signUpUser(
                    //     username: providerData.name,
                    //     email: email,
                    //     password: password);

                    // final userCred = await _auth.signInWithEmailAndPassword(
                    //     email: email, password: password);
                    // final user = userCred.user;

                    // user?.sendEmailVerification();
                  },
                  style: ElevatedButton.styleFrom(
                      // primary: Colors.deepPurple, // Background color
                      // onPrimary: Colors.white, // Text color
                      ),
                ),
              ),
              SizedBox(height: 16),
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     child: Text('Sign in with Apple'),
              //     onPressed: () {
              //       // Handle sign in with Apple action
              //     },
              //     style: ElevatedButton.styleFrom(
              //       primary: Colors.black, // Background color
              //       onPrimary: Colors.white, // Text color
              //     ),
              //   ),
              // ),
              SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }
}
