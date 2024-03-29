import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:waste_ai/providers/app_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:waste_ai/screens/profile_screen.dart';

class InvasiveSpecieSpottingDetailsScreen extends StatefulWidget {
  final String userId;
  final String markerId;
  const InvasiveSpecieSpottingDetailsScreen(
      {super.key, required this.userId, required this.markerId});

  @override
  State<InvasiveSpecieSpottingDetailsScreen> createState() =>
      _InvasiveSpecieSpottingDetailsScreenState();
}

class _InvasiveSpecieSpottingDetailsScreenState
    extends State<InvasiveSpecieSpottingDetailsScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Map<String, dynamic>? markerInformation;
  Map<String, dynamic>? userWhoSpottedInformation = {
    'name': '',
    'profilePicture': '',
    'level': ''
  };

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat("MMMM d', 'yyyy").format(dateTime);

    // Add the suffix for the day
    String daySuffix;
    int dayOfMonth = dateTime.day;
    if (dayOfMonth >= 11 && dayOfMonth <= 13) {
      daySuffix = 'th';
    } else {
      switch (dayOfMonth % 10) {
        case 1:
          daySuffix = 'st';
          break;
        case 2:
          daySuffix = 'nd';
          break;
        case 3:
          daySuffix = 'rd';
          break;
        default:
          daySuffix = 'th';
      }
    }
// $daySuffix
    return '$formattedDate';
  }

  Future<void> getMarkerInformation() async {
    DocumentSnapshot docSnapshot = await firestore
        .collection(
            'users') // Make sure the collection name is correct (users, not uesrs)
        .doc(widget.userId)
        .collection('SavedInvasiveSpecieImages')
        .doc(widget.markerId)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        print('it exists');
        markerInformation = docSnapshot.data() as Map<String, dynamic>?;
        print('this is the url');
        print(markerInformation?['url']);
      });
    } else {
      print('does not exist');
    }

    DocumentSnapshot userWhoSpottedInformationSnapshot =
        await firestore.collection('users').doc(widget.userId).get();

    if (userWhoSpottedInformationSnapshot.exists) {
      Map<String, dynamic> data =
          userWhoSpottedInformationSnapshot.data() as Map<String, dynamic>;
      setState(() {
        userWhoSpottedInformation = {
          'name': data['name'] ?? '',
          'profilePicture': data['profile_picture'] ?? '',
          'level': data['level'] ?? ''
        };
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getMarkerInformation(); // Call your function in initState
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<AppProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Invasive Specie Details'),
        backgroundColor: const Color.fromRGBO(44, 130, 124, 1.0),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                  width: double
                      .infinity, // Set the width to the maximum available width
                  height: 300, // Set the fixed height to 300
                  child: markerInformation != null
                      ? Image.network(
                          markerInformation?['url'],
                          fit: BoxFit
                              .cover, // Cover the container while preserving the aspect ratio
                        )
                      : CircularProgressIndicator()),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spotted Laternfly',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.w800),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 5),
                          if (markerInformation != null &&
                              markerInformation!['timestamp'] != null)
                            Text(
                              'Spotted ${formatTimestamp(markerInformation!['timestamp'] as Timestamp)}',
                              style: TextStyle(color: Colors.black54),
                            ),
                        ],
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                    userIdBeingViewed: widget.userId))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(
                                userWhoSpottedInformation?['profilePicture']
                                        as String? ??
                                    '',
                              ),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userWhoSpottedInformation?['name'] ?? '',
                                  style: TextStyle(fontSize: 25),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color.fromRGBO(44, 130, 124, 1.0),
                                        Color.fromARGB(255, 34, 104, 99),
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Text(
                                    'Level ${userWhoSpottedInformation?['level'] ?? ''}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Details of Invasive Specie',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 15),
                      Text(
                          'Spotted Lanternfly (SLF) is an invasive insect that has spread throughout Pennsylvania since its discovery in Berks County in 2014. The Spotted Lanternfly feeds on sap from over 70 different plant species. It has a strong preference for economically important plants including grapevines, maple trees, black walnut, birch, willow, and other trees. The feeding damage can lead to decreased health and potentially death.'),
                      SizedBox(height: 15),
                      Text(
                        'Location of Spotting',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: GoogleMapWidget())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('id'),
      position: LatLng(37.785299, -122.859734),
      infoWindow: InfoWindow.noText,
    ),
  };
  late Future<void> _loadMap;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> getPhotoLocations() async {
    String? userId = auth.currentUser?.uid;

    if (userId == null) {
      print('No user logged in.');
      return;
    }

    // Fetch the snapshots for invasive and non-invasive species
    var nonInvasiveQuerySnapshot = await firestore
        .collection("users")
        .doc(userId)
        .collection("SavedNonInvasiveSpecieImages")
        .get();

    // Prepare a list of futures for creating markers
    List<Future<Marker>> markerFutures = [];

    Future<Uint8List> getBytesFromNetworkUrl(String url) async {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Decode the image to an Image object
        img.Image? image = img.decodeImage(response.bodyBytes);
        // Resize the image to a smaller width and height
        img.Image resized = img.copyResize(image!, width: 200, height: 200);
        // Encode the image to PNG
        return Uint8List.fromList(img.encodePng(resized));
      }
      throw HttpException('Failed to load marker icon');
    }

    // Iterate through each document, create a future for fetching the image and creating a marker
    for (var doc in nonInvasiveQuerySnapshot.docs) {
      var futureMarker =
          getBytesFromNetworkUrl(doc.data()['url'] as String).then((byteData) {
        return Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(
              doc.data()['latitude'] as double,
              doc.data()['longitude'] as double,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow.noText);
      });
      markerFutures.add(futureMarker);
    }

    // Once all futures are completed, set the markers state
    final List<Marker> markers = await Future.wait(markerFutures);
    print(markers);
    setState(() {
      _markers = markers.toSet();
    });
  }

  @override
  void initState() {
    super.initState();

    _loadMap = getPhotoLocations();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadMap,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromRGBO(97, 157, 92, 1.0),
            ),
          );
        } else {
          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.785834, -122.406417), // San Francisco
              zoom: 10,
            ),
            markers: _markers,
          );
        }
      },
    );
  }
}
