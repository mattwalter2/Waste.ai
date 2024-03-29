import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waste_ai/providers/app_provider.dart';
import 'package:waste_ai/screens/account_settings_screen.dart';
import 'package:waste_ai/screens/privacy_policy_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<AppProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color.fromRGBO(44, 130, 124, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: <Widget>[
            ListTile(
                title: Text('Account Settings'),
                leading: Icon(Icons.account_circle),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountSettingsScreen()),
                  );
                }),
            ListTile(
              title: Text('Privacy Policy'),
              leading: Icon(Icons.privacy_tip),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen()),
                );
                ;
                // Navigate to privacy policy screen
              },
            ),
            ListTile(
              title: Text('Log Out'),
              leading: Icon(Icons.logout),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                providerData.changeSelectedIndex(0);
                providerData.changeUserSignIn();
                // Handle log out action
              },
            ),
            ListTile(
                title: Text(
                  'Delete Account',
                  style: TextStyle(color: Color.fromARGB(255, 255, 97, 97)),
                ),
                leading: Icon(
                  Icons.delete_forever,
                  color: Color.fromARGB(255, 255, 97, 97),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => DeleteAccountDialog1(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class DeleteAccountDialog1 extends StatefulWidget {
  const DeleteAccountDialog1({super.key});

  @override
  State<DeleteAccountDialog1> createState() => _DeleteAccountDialog1State();
}

class _DeleteAccountDialog1State extends State<DeleteAccountDialog1> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<AppProvider>(context, listen: true);
    return AlertDialog(
        title: Text(
          'Are you sure you want to delete your account?',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.white), // Text color is white
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => DeleteAccountDialog2(),
                  );
                },
                style: TextButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                  backgroundColor:
                      Colors.red, // Button background color is purple
                  // primary: Colors.white, // Ripple effect color is white
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Rounded corner radius
                    side: BorderSide(
                        color: Colors
                            .red), // Border color is purple to match the background
                  ),
                ),
              ),
              TextButton(
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.black), // Text color is black
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                style: TextButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                  minimumSize: Size.zero,
                  // primary: Colors.black, // Ripple effect color is black
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Rounded corner radius
                    side: BorderSide(
                        color: Colors.black), // Border color is black
                  ),
                ),
              ),
            ],
          )
        ]);
  }
}

class DeleteAccountDialog2 extends StatefulWidget {
  const DeleteAccountDialog2({super.key});

  @override
  State<DeleteAccountDialog2> createState() => _DeleteAccountDialog2State();
}

class _DeleteAccountDialog2State extends State<DeleteAccountDialog2> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<AppProvider>(context, listen: true);
    return AlertDialog(
        title: Text(
          'Clicking Yes Will Permanently Delete Your Account',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                child: Text(
                  'Yes, Delete My Account',
                  style: TextStyle(color: Colors.white), // Text color is white
                ),
                onPressed: () async {
                  try {
                    // Assuming you have an instance of FirebaseAuth
                    FirebaseAuth auth = FirebaseAuth.instance;
                    User? user = auth.currentUser;

                    if (user != null) {
                      await user.delete();
                      Navigator.pop(context, true);
                      providerData.checkUserSignedIn();
                      providerData.changeSelectedIndex(0);
                      // Handle successful account deletion.
                      // For example, navigate the user to the sign-in screen.
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'requires-recent-login') {
                      // The user must reauthenticate before this operation can be executed.
                    }
                    // Handle other FirebaseAuthExceptions.
                  }
                },
                style: TextButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                  backgroundColor:
                      Colors.red, // Button background color is purple
                  // primary: Colors.white, // Ripple effect color is white
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Rounded corner radius
                    side: BorderSide(
                        color: Colors
                            .red), // Border color is purple to match the background
                  ),
                ),
              ),
              TextButton(
                child: Text(
                  'No, Do Not Delete My Account',
                  style: TextStyle(color: Colors.black), // Text color is black
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                style: TextButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                  minimumSize: Size.zero,
                  // primary: Colors.black, // Ripple effect color is black
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Rounded corner radius
                    side: BorderSide(
                        color: Colors.black), // Border color is black
                  ),
                ),
              ),
            ],
          )
        ]);
  }
}
