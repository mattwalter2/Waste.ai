import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:waste_ai/providers/app_provider.dart';

import 'package:waste_ai/screens/home_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isInvasive = true;
  bool showResult =
      false; // Flag to show/hide the result// Example flag for invasive species detection
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _resultPredictionPercentage;
  String? _resultClassPrediction;
  List<dynamic>? BoundedBoxCoordinates;
  bool invasiveSpecieDetected = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, String> badgeLocalPaths = {
    'Badge1': 'assets/Badge1.png',
    'Badge2': 'assets/Badge2.png'
  };
  Map<String, String> badgeDownloadUrls = {'Badge1': '', 'Badge2': ''};

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  Future<void> setBadgeDownloadUrls() async {
    for (String badgeName in badgeLocalPaths.keys) {
      // Get the asset path for the badge
      String assetPath = badgeLocalPaths[badgeName]!;

      // Load the asset as bytes
      ByteData byteData = await rootBundle.load(assetPath);
      Uint8List assetBytes = byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);

      // Create a reference in Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('badges/${DateTime.now().millisecondsSinceEpoch}');

      // Upload the bytes
      await ref.putData(assetBytes);

      // Get the download URL
      String badgeDownloadUrl = await ref.getDownloadURL();

      // Update the badgeDownloadUrls map
      badgeDownloadUrls[badgeName] = badgeDownloadUrl;
    }
    print(badgeDownloadUrls);
  }

  Future<void> saveImageandLocation(XFile? image,
      {required bool invasiveImage,
      required Position position,
      required BuildContext context}) async {
    final providerData = Provider.of<AppProvider>(context, listen: false);
    print('can you see this');
    if (image == null) return;
    File file = File(image.path);
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}');

      // Upload the file
      await ref.putFile(file);

      // Get the download URL
      String downloadUrl = await ref.getDownloadURL();
      if (invasiveImage) {
        await firestore
            .collection('users')
            .doc(auth.currentUser!.uid) // Use the user's UID as the document ID
            .collection('SavedInvasiveSpecieImages')
            .add({
          'user_who_saved_uid': auth.currentUser!.uid,
          'url': downloadUrl,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': FieldValue
              .serverTimestamp(), // Saves the time of the location update
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return EditProfilePictureDialog();
          },
        );
        if (providerData.experience + 100 >= 500) {
          // User should level up

          firestore
              .collection('users')
              .doc(auth.currentUser!.uid)
              .update({'level': providerData.level + 1, 'experience': 0});
          providerData.updateExperience(0);
          providerData.updateLevel(providerData.level + 1);
        } else {
          // Only experience is added to the User

          firestore
              .collection('users')
              .doc(auth.currentUser!.uid)
              .update({'experience': providerData.experience + 100});
          providerData.updateExperience(providerData.experience + 100);
        }
        firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .update({'total_catches': providerData.totalCatches + 1});
        providerData.updateTotalCatches(providerData.totalCatches + 1);
        if (providerData.totalCatches == 10) {
          firestore.collection('users').doc(auth.currentUser!.uid).update({
            'badges': FieldValue.arrayUnion([badgeDownloadUrls['Badge2']])
          });
          providerData.addBadge(badgeLocalPaths['Badge2']!);
        } else if (providerData.totalCatches == 5) {
          firestore.collection('users').doc(auth.currentUser!.uid).update({
            'badges': FieldValue.arrayUnion([badgeDownloadUrls['Badge1']])
          });
          providerData.addBadge(badgeLocalPaths['Badge1']!);
        }
      } else {
        await firestore
            .collection('users')
            .doc(auth.currentUser!.uid) // Use the user's UID as the document ID
            .collection('SavedNonInvasiveSpecieImages')
            .add({
          'url': downloadUrl,

          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': FieldValue
              .serverTimestamp(), // Saves the time of the location update
        });
      }

      print('Download URL: $downloadUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _captureImage() async {
    print('capturing image');
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = pickedImage;
    });
  }

  Future<void> _handleSubmit(BuildContext context) async {
    // await firestore.collection('users').add({
    //   'name': 'John Doe',
    //   'age': 30,
    //   'email': 'johndoe@example.com',
    // }).then((DocumentReference doc) {
    //   print('Document added with ID: ${doc.id}');
    // }).catchError((e) {
    //   print('Error adding document: $e');
    // });
    print('submit being handled');
    Position positionOfPhoto = await _determinePosition();
    print(_image);
    if (_image != null) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://biowatch.onrender.com/detect'));
      request.files
          .add(await http.MultipartFile.fromPath('file', _image!.path));
      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          print(response.stream);
          var responseData = await response.stream.toBytes();

          var responseString = String.fromCharCodes(responseData);
          var responseJson = json.decode(responseString);

          print(
              "top"); // Now you can access the dictionary (JSON object) using responseJson
          print(responseJson); // This will print the whole JSON object
          print(responseJson['detections']);
          print("bottom");
          try {
            String classPredictionNumber =
                responseJson['detections'][0]['classes'][0].toInt().toString();
            print(responseJson['detections'][0]['boxes'][0]);
            BoundedBoxCoordinates = responseJson['detections'][0]['boxes'][0];
            print(
                responseJson['detections'][0]['names'][classPredictionNumber]);
            setState(() {
              _resultPredictionPercentage =
                  responseJson['detections'][0]['scores'][0].toString();
              _resultClassPrediction =
                  responseJson['detections'][0]['names'][classPredictionNumber];

              invasiveSpecieDetected = true;
              showResult = true;
            });
            saveImageandLocation(_image,
                invasiveImage: true,
                position: positionOfPhoto,
                context: context);
          } catch (e) {
            setState(() {
              invasiveSpecieDetected = false;
              showResult = true;
            });
            saveImageandLocation(_image,
                invasiveImage: false,
                position: positionOfPhoto,
                context: context);
          }
        } else {
          print('Server error: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  // Future<void> _savePositionToFirebase(Position position) async {
  //   FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid).collec   add({
  //     'latitude': position.latitude,
  //     'longitude': position.longitude,
  //     'timestamp':
  //         FieldValue.serverTimestamp(), // Saves the time of the location update
  //   });
  // }

  @override
  void initState() {
    super.initState();
    setBadgeDownloadUrls(); // Call your function in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
        backgroundColor: Color.fromRGBO(44, 130, 124, 1.0),
      ),
      body: Column(
        children: <Widget>[
          // Visibility(
          //   visible: showResult,
          //   child: Text(
          //     isInvasive
          //         ? 'Invasive Species Detected'
          //         : 'No Invasive Species Detected',
          //     style: TextStyle(
          //         color: isInvasive ? Colors.red : Colors.green,
          //         fontSize: 18),
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                showResult && invasiveSpecieDetected
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 255, 97, 97),
                        ),
                        height: 60,
                        width: double.infinity,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Invasive Species Detected',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                              Text(
                                '$_resultClassPrediction Spotted Lantern Fly',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              // Text(
                              //   '${(double.parse(_resultPredictionPercentage!) * 100).round().toString()}% accuracy',
                              //   style: TextStyle(
                              //       color: Colors.white, fontWeight: FontWeight.w600),
                              // ),
                            ],
                          ),
                        ),
                      )
                    : showResult
                        ? Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color.fromRGBO(121, 199, 115, 1.0),
                            ),
                            child: Center(
                              child: Text(
                                'No Invasive Species Detected',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          )
                        : Container(),
                SizedBox(height: 10),
                Stack(
                  children: [
                    _image != null
                        ? Container(
                            width: double.infinity,
                            height: 375,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Image.file(
                                File(_image!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            height: 375,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.green, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.personMilitaryPointing,
                                  color: Color.fromARGB(255, 85, 85, 85),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'No Photo\nSelected',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 85, 85, 85)),
                                )
                              ],
                            ),
                          ),
                    // invasiveSpecieDetected == true
                    //     ? CustomPaint(
                    //         painter: RectanglePainter(
                    //           topLeft: Offset(BoundedBoxCoordinates![2],
                    //               BoundedBoxCoordinates![3]),
                    //           bottomRight: Offset(BoundedBoxCoordinates![0],
                    //               BoundedBoxCoordinates![1]),
                    //         ),
                    //       )
                    //     : Container()
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _pickImage();
                            // Handle button press
                          },
                          child: CircleAvatar(
                            foregroundColor: Colors.white,

                            child: Icon(Icons
                                .photo_album), // Replace with your desired icon
                            // Optionally, set the background color:
                            backgroundColor: Color.fromRGBO(97, 157, 92, 1.0),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Upload Image',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _captureImage();
                            // Handle button press
                          },
                          child: CircleAvatar(
                            foregroundColor: Colors.white,

                            child: Icon(
                                Icons.camera), // Replace with your desired icon
                            // Optionally, set the background color:
                            backgroundColor: Color.fromRGBO(97, 157, 92, 1.0),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Capture Photo',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(
                          121, 199, 115, 1.0), // Set the background color
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(50), // Set the border radius
                      ), // Set the text color
                    ),
                    onPressed: () {
                      _handleSubmit(context);
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfilePictureDialog extends StatefulWidget {
  @override
  _EditProfilePictureDialogState createState() =>
      _EditProfilePictureDialogState();
}

class _EditProfilePictureDialogState extends State<EditProfilePictureDialog> {
  bool imageSelected = false;
  File? _imageFile;
  XFile? image;

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image!.path);
        imageSelected = true;
      });
    }
  }

  Future<void> captureImage() async {
    final ImagePicker _picker = ImagePicker();
    image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _imageFile = File(image!.path);
        imageSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<AppProvider>(context, listen: true);
    return AlertDialog(
      title: Text('Invasive Specie Detected!'),
      content: Image.asset(
        'assets/InvasiveSpecieDetectedImage.png',
        width: 100,
        height: 100,
      ),
      actions: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('You just detected a Spotted Laternfly'),
            Text('Earned 100xp'),
            TextButton(
              child: Text(
                'Continue',
                style: TextStyle(color: Colors.white), // Text color is black
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                // primary: Colors.black, // Ripple effect color is black
                minimumSize: Size.zero,
                backgroundColor: Color.fromRGBO(44, 130, 124, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8.0), // Rounded corner radius
                  // Border color is black
                ),
              ),
            ),
            if (imageSelected)
              TextButton(
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.black), // Text color is black
                ),
                onPressed: () async {
                  // var uuid = Uuid();
                  // String generatedUuid =
                  //     uuid.v4(); // Generate a v4 UUID (random)
                  // print("hey");
                  // await awsDataStore.uploadIOFile(_imageFile!, generatedUuid);
                  // print("hey not");
                  // await awsDataStore.updateProfilePicture(
                  //     providerData.userId, generatedUuid);
                  // String? profilePictureUrl =
                  //     await awsDataStore.getProfilePicture(
                  //         imageKey: generatedUuid,
                  //         accessLevel: StorageAccessLevel.guest);

                  print('this is profile url');
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
      ],
    );
  }
}
