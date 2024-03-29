import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:waste_ai/main_navigator.dart';
import 'package:waste_ai/providers/app_provider.dart';
import 'package:waste_ai/screens/another_user_screen.dart';
import 'dart:convert';

import 'package:waste_ai/screens/home_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:waste_ai/screens/login_screen.dart';
import 'package:waste_ai/screens/profile_2_screen.dart';
import 'firebase_options.dart';

// ...

void main() async {
// ...
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
        // You can add more providers here as needed.
      ],
      child: MaterialApp(
        theme: ThemeData(
          bottomAppBarTheme:
              BottomAppBarTheme(color: Colors.white, elevation: 0),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color.fromRGBO(44, 130, 124, 1.0),
            titleTextStyle: TextStyle(
              fontSize: 20.0, // Set the font size
              fontWeight: FontWeight.w600, // Set the font weight
              color: Colors.white, // Set the text color
            ),
            iconTheme: IconThemeData(
              color: Colors.white, // Set the color of action icons to white
            ),
          ),
        ),
        home: MainNavigator(),
      ),
    );
  }
}
