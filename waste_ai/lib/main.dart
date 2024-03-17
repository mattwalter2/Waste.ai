import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _result;

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  Future<void> _handleSubmit() async {
    if (_image != null) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://localhost:5000/predict'));
      request.files
          .add(await http.MultipartFile.fromPath('file', _image!.path));
      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          print(response.stream);
          var responseData = await response.stream.toBytes();

          var responseString = String.fromCharCodes(responseData);
          var responseJson = json.decode(responseString);

          // Now you can access the dictionary (JSON object) using responseJson
          print(responseJson); // This will print the whole JSON object
          print(responseJson['prediction']);

          setState(() {
            _result = responseJson['prediction'];
          });
        } else {
          print('Server error: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Image Upload Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _image != null
                  ? Image.file(File(_image!.path))
                  : Text('No image selected'),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Upload Image'),
              ),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text('Submit'),
              ),
              _result != null ? Text('Your Image Is: $_result') : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
