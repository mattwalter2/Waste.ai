import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:waste_ai/providers/app_provider.dart';

import 'package:waste_ai/screens/home_screen.dart';
import 'package:waste_ai/screens/invasive_specie_spotting_details_screen.dart';
import 'package:waste_ai/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _resultPredictionPercentage;
  String? _resultClassPrediction;
  List<dynamic>? BoundedBoxCoordinates;
  bool? invasiveSpecieDetected;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  Future<void> _captureImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = pickedImage;
    });
  }

  List<SpecieInfo> species = [
    SpecieInfo('assets/SpottedLaternfly.jpeg', 'jane level 2'),
    // Add two more entries or duplicate the first one for the example
    SpecieInfo('assets/SpottedLaternfly.jpeg', 'jane level 2'),
    SpecieInfo('assets/SpottedLaternfly.jpeg', 'jane level 2'),
  ];

  Future<void> _handleSubmit() async {
    if (_image != null) {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://127.0.0.1:5000/detect'));
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
            });
          } catch (e) {
            setState(() {
              invasiveSpecieDetected = false;
            });
          }
        } else {
          print('Server error: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }

    // Future<List<Map<String, dynamic>>> getTopUsersByTotalCatches() async {
    //   List<Map<String, dynamic>> topUsers = [];

    //   // Query users collection, ordered by total_catches in descending order, limited to top 4
    //   QuerySnapshot querySnapshot = await firestore
    //       .collection('users')
    //       .orderBy('total_catches', descending: true)
    //       .limit(4)
    //       .get();

    //   for (var doc in querySnapshot.docs) {
    //     Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
    //     topUsers.add({
    //       'user_id': doc.id,
    //       'name': userData['name'] ?? '',
    //       'total_catches': userData['total_catches'] ?? 0,
    //     });
    //   }

    //   return topUsers;
    // }
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<AppProvider>(context, listen: true);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      scale: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                        userIdBeingViewed: 'test',
                                      )),
                            )
                          },
                          child: Stack(
                            children: [
                              // SizedBox(
                              //   width: 100, // Adjust the size to your preference
                              //   height: 100, // Adjust the size to your preference
                              //   child: CircularProgressIndicator(
                              //     value:
                              //         0.1, // The value should be between 0.0 and 1.0
                              //     strokeWidth:
                              //         10, // Adjust the thickness of the progress indicator
                              //   ),
                              // ),
                              CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(
                                    providerData.profilePictureUrl),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      providerData.name,
                                      style: TextStyle(
                                        color: Colors.white, // Text color
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            10, // You can adjust the font size
                                      ),
                                    ),
                                  ),
                                  width: 10 * 5,
                                  height: 10 * 2,
                                  decoration: BoxDecoration(
                                      // Define the gradient
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromRGBO(44, 130, 124, 1.0),
                                          Color.fromARGB(255, 34, 104,
                                              99), // Lighter purple shade at the top left
                                          // Darker purple shade at the bottom right
                                        ],
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              10)) // Keep it as a circle
                                      ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(height: 14),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 97, 97),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(
                            0.5), // Shadow color with some transparency
                        spreadRadius:
                            1, // Spread radius (how much the shadow should spread)
                        blurRadius: 5, // Blur radius (the size of the shadow)
                        offset: Offset(0, 3), // Position of the shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'ALERT: The Spotted Lanternfly has been detected near the PSU Arboretum. Consider scanning in the area to help detect more! ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                      // Define the gradient
                      color: Color.fromRGBO(44, 130, 124, 1.0),
                      borderRadius: BorderRadius.all(
                          Radius.circular(10)) // Keep it as a circle
                      ),
                  width: double.infinity,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Tip: saving a scan is worth 50xp and reporting an invasive species is worth 250xp!',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                SizedBox(height: 20),
                LeaderboardWidget(),
                SizedBox(
                  height: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  final Offset topLeft;
  final Offset bottomRight;

  RectanglePainter({required this.topLeft, required this.bottomRight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromPoints(topLeft, bottomRight);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SpecieInfo {
  final String imagePath;
  final String name;

  SpecieInfo(this.imagePath, this.name);
}

class LeaderboardWidget extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getTopUsers() async {
    // Fetch the top four users with the highest total_catches
    QuerySnapshot snapshot = await firestore
        .collection('users')
        .orderBy('total_catches', descending: true)
        .limit(4)
        .get();

    // Extract the user data and return it
    return snapshot.docs
        .map((doc) => {
              'userId': doc.id,
              'name': doc['name'],
              'level': doc['level'],
              'experience': doc['experience'],
              'total_catches': doc['total_catches'],
            })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
        SizedBox(height: 10),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: getTopUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<Map<String, dynamic>> users = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                userIdBeingViewed: users[index]['userId'])),
                      )
                    },
                    child: ListTile(
                      horizontalTitleGap: 10,
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue,
                      ),
                      title: Container(
                        margin: EdgeInsets.only(right: 80),
                        child: Center(
                          child: Text(
                            users[index]['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        height: 25,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(44, 130, 124, 1.0),
                              Color.fromARGB(255, 34, 104, 99),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      subtitle: Text(
                        'Level ${users[index]['level']} (${users[index]['experience']}/500xp)',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w600),
                      ),
                      trailing: Text(
                        '${index + 1}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Text('No users found');
            }
          },
        ),
        NearbyScansWidget()
      ],
    );
  }
}

class NearbyScansWidget extends StatefulWidget {
  const NearbyScansWidget({super.key});

  @override
  State<NearbyScansWidget> createState() => _NearbyScansWidgetState();
}

class _NearbyScansWidgetState extends State<NearbyScansWidget> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Future<List<Map<String, dynamic>>> _nearbyScansFuture;

  Future<List<Map<String, dynamic>>> getNearbyScans() async {
    QuerySnapshot snapshot = await firestore
        .collectionGroup('SavedInvasiveSpecieImages')
        .limit(5)
        .get();

    return snapshot.docs.map((doc) {
      return {
        'userId': doc['user_who_saved_uid'],
        'url': doc['url'],
        'timestamp': doc['timestamp'],
        'latitude': doc['latitude'],
        'longitude': doc['longitude'],
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _nearbyScansFuture = getNearbyScans();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nearby Scans',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
        SizedBox(height: 14),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _nearbyScansFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<Map<String, dynamic>> scans = snapshot.data!;
              return SizedBox(
                height: 270,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: scans.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    InvasiveSpecieSpottingDetailsScreen(
                                  userId: scans[index]['userId'],
                                  markerId:
                                      'test', // Replace with actual markerId
                                ),
                              ),
                            )
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            margin: EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(scans[index]['url']),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  userIdBeingViewed: scans[index]['userId'],
                                ),
                              ),
                            )
                          },
                          child: Container(
                            width: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(
                                    scans[index]['url'],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [Text('Name'), Text('Level')],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            } else {
              return Text('No nearby scans found');
            }
          },
        ),
      ],
    );
  }
}
