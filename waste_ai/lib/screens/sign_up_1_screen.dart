import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:ffi';
import 'package:provider/provider.dart';
import 'package:waste_ai/providers/app_provider.dart';

class SignUp1Screen extends StatefulWidget {
  final VoidCallback? checkUserSignedIn;
  const SignUp1Screen({super.key, this.checkUserSignedIn});

  @override
  State<SignUp1Screen> createState() => _SignUp1ScreenState();
}

class _SignUp1ScreenState extends State<SignUp1Screen> {
  final TextEditingController nameController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool imageSelected = false;
  File? _imageFile;
  String name = "";
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        imageSelected = true;
      });
    }
    print(_imageFile);
  }

  bool _showNameError = false; // Add this line

  void _trySignUp() async {
    final providerData = Provider.of<AppProvider>(context, listen: false);

    if (nameController.text.isNotEmpty) {
      if (_imageFile != null) {
        File file = File(_imageFile!.path);
        try {
          // Create a reference to the location you want to upload to in Firebase Storage
          Reference ref = FirebaseStorage.instance
              .ref()
              .child('images/${DateTime.now().millisecondsSinceEpoch}');

          // Upload the file
          await ref.putFile(file);

          // Get the download URL
          String downloadUrl = await ref.getDownloadURL();
          providerData.setProfilePictureUrl(downloadUrl);

          providerData
              .changeSelectedIndex(2); // Move this line inside the try block
        } catch (e) {
          print('Error uploading image: $e');
        }
      } else {
        // Handle the case where the image file is null
        print('No image selected');
      }
    } else {
      setState(() {
        _showNameError = true; // Set this to true to show the error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<AppProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Color.fromRGBO(86, 3, 173, 1),
          onPressed: () {
            providerData.changeSelectedIndex(0);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Row(children: [
                //   Image.asset('assets/marble_logo.png',
                //       width: 100, height: 100),
                //   ChatBubble(text: "Let's start by building your profile"),
                // ]),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Call the getImage function when the user taps on the circle
                    pickImage();
                  },
                  child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade800,
                      backgroundImage:
                          imageSelected ? FileImage(_imageFile!) : null),
                ),
                SizedBox(height: 50),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    errorText: _showNameError
                        ? 'Name required'
                        : null, // Add this line
                    errorStyle: TextStyle(
                        color: Colors.red), // Add this line for error style
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      providerData.updateName(nameController.text);
                      print(providerData.name);

                      _trySignUp();
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(86, 3, 173, 1),
                      side: BorderSide(color: Color.fromRGBO(86, 3, 173, 1)),
                      // width and height
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
