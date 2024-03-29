import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:waste_ai/providers/app_provider.dart';

class AccountSettingsScreen extends StatefulWidget {
  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  TextEditingController _nameController = TextEditingController();

  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  Future<void> _getUserInformation() async {
    var userInformationData =
        await firestore.collection("users").doc(auth.currentUser!.uid).get();
    setState(() {
      _nameController.text = userInformationData.data()!['name'];
      _genderController.text = userInformationData.data()!['gender'];
      _birthDateController.text = userInformationData.data()!['birth date'];
    });
  }

  Future<void> _handleSubmit() async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'name': _nameController.text,
      'gender': _genderController.text,
      'birth date': _birthDateController.text
    }); // Use the user's UID as the document ID
  }

  @override
  void initState() {
    super.initState();
    final providerData = Provider.of<AppProvider>(context, listen: false);
    _nameController.text = providerData.name;

    // _getUserInformation();
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<AppProvider>(context, listen: false);

    ImageProvider? profilePictureToUpload;
    if (_image != null) {
      profilePictureToUpload = FileImage(File(_image!.path));
    } else if (providerData.profilePictureUrl.isNotEmpty) {
      profilePictureToUpload = NetworkImage(providerData.profilePictureUrl);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(44, 130, 124, 1.0),
        title: Text('Account Settings'),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 32),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  GestureDetector(
                      onTap: () async {
                        await _pickImage();
                        print('picking image');
                      },
                      child: CircleAvatar(
                          backgroundColor: Color.fromRGBO(211, 211, 211, 1.0),
                          radius: 60,
                          backgroundImage: profilePictureToUpload)),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.black54),
                    onPressed: () {
                      // TODO: Change profile picture
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            SizedBox(height: 12),
            buildTextField(
                controller: _nameController,
                labelText: 'Name',
                hintText: 'Name'),
            SizedBox(height: 12),
            // buildTextField(
            //     controller: _emailController,
            //     labelText: 'E-mail',
            //     hintText: 'E-mail'),
            // SizedBox(height: 12),
            // buildTextField(
            //     controller: _genderController,
            //     labelText: 'Gender',
            //     hintText: 'Gender'),
            // SizedBox(height: 12),
            // buildTextField(
            //     controller: _birthDateController,
            //     labelText: 'Birth date',
            //     hintText: 'Birth date'),
            // SizedBox(height: 20),
            Container(
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  String profilePictureToUploadUrl = '';
                  if (_image != null) {
                    Reference ref = FirebaseStorage.instance.ref().child(
                        'images/${DateTime.now().millisecondsSinceEpoch}');

                    // Upload the file
                    await ref.putFile(File(_image!.path));
                    profilePictureToUploadUrl = await ref.getDownloadURL();
                  }

                  // Get the download URL

                  providerData.setUserInfo(
                      _nameController.text,
                      auth.currentUser!.uid,
                      profilePictureToUploadUrl.toString(),
                      providerData.level,
                      providerData.experience,
                      providerData.totalCatches,
                      providerData.badges);
                  await firestore
                      .collection('users')
                      .doc(auth.currentUser!.uid)
                      .update({
                    'name': _nameController.text,
                    'profile_picture': profilePictureToUploadUrl.toString()
                  });

                  // Implement save functionality
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30), // Set your border radius here
                  ),
                  backgroundColor: Color.fromRGBO(
                      121, 199, 115, 1.0), // button background color
                  foregroundColor: Colors.white, // button text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      {required TextEditingController controller,
      required String labelText,
      required String hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal:
                    10), // Reduces height by reducing padding inside the TextField
            hintText: 'adsds',

            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey.shade300), // Customise border color here
              borderRadius: BorderRadius.circular(50.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromRGBO(97, 157, 92,
                      1.0)), // Customise border color when TextField is focused
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
