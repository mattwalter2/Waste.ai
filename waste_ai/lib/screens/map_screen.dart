import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:url_launcher/url_launcher.dart';
import 'package:waste_ai/screens/invasive_specie_spotting_details_screen.dart';
import 'package:waste_ai/screens/saved_photos_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        backgroundColor: const Color.fromRGBO(44, 130, 124, 1.0),
      ),
      body: const GoogleMapWidget(),
    );
  }
}

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  Map<String, Marker> markerUserIdMap = {};
  Set<Marker> _markers = {};
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

    QuerySnapshot invasiveQuerySnapshot =
        await firestore.collectionGroup("SavedInvasiveSpecieImages").get();

    print(invasiveQuerySnapshot.size);
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
    // Iterate through each document, create a future for fetching the image and creating a marker
    for (var doc in invasiveQuerySnapshot.docs) {
      var docData =
          doc.data() as Map<String, dynamic>?; // Add a null check here
      if (docData != null) {
        print('inside for loop');
        // Check if docData is not null
        var futureMarker =
            getBytesFromNetworkUrl(docData['url'] as String).then((byteData) {
          return Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(
                docData['latitude'] as double,
                docData['longitude'] as double,
              ),
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            InvasiveSpecieSpottingDetailsScreen(
                                userId: doc.get('user_who_saved_uid'),
                                markerId: doc.id)),
                  ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              infoWindow: InfoWindow.noText);
        });
        markerFutures.add(futureMarker);
        print('marker added');
      }
    }
    // Once all futures are completed, set the markers state
    try {
      final List<Marker> markers = await Future.wait(markerFutures);
      print('yo');
      print(markers);
      setState(() {
        _markers = markers.toSet();
      });
    } catch (e) {
      print('Error occurred: $e');
    }
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
