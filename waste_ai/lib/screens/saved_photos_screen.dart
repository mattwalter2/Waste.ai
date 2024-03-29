import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:waste_ai/screens/invasive_specie_spotting_details_screen.dart';

class SavedPhotosScreen extends StatefulWidget {
  const SavedPhotosScreen({super.key});

  @override
  State<SavedPhotosScreen> createState() => _SavedPhotosScreenState();
}

class _SavedPhotosScreenState extends State<SavedPhotosScreen> {
  String selectedPhotoType = 'Invasive';
  Map<String, List<NetworkImage>> savedSpeciesPhotoUrls = {
    'savedInvasiveSpeciePhotoUrls': [],
    'savedNonInvasiveSpeciePhotoUrls': []
  };
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> fetchDocuments() async {
    String? userId = auth.currentUser?.uid; // Handle potential null value.

    if (userId == null) {
      print('No user logged in.');
      return;
    }

    // Fetch invasive species photo URLs
    var invasiveQuerySnapshot = await db
        .collection("users")
        .doc(userId)
        .collection("SavedInvasiveSpecieImages")
        .get();

    List<String> invasiveUrls = invasiveQuerySnapshot.docs
        .map((doc) => doc.data()['url'] as String)
        .toList();

    // Fetch non-invasive species photo URLs
    var nonInvasiveQuerySnapshot = await db
        .collection("users")
        .doc(userId)
        .collection("SavedNonInvasiveSpecieImages")
        .get();

    List<String> nonInvasiveUrls = nonInvasiveQuerySnapshot.docs
        .map((doc) => doc.data()['url'] as String)
        .toList();

    setState(() {
      savedSpeciesPhotoUrls['savedInvasiveSpeciePhotoUrls'] =
          invasiveUrls.map((url) => NetworkImage(url)).toList();
      savedSpeciesPhotoUrls['savedNonInvasiveSpeciePhotoUrls'] =
          nonInvasiveUrls.map((url) => NetworkImage(url)).toList();
    });
  }

  void initState() {
    super.initState();
    fetchDocuments();
    // Call the method to check the user's sign-in status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Photos'),
        backgroundColor: Color.fromRGBO(44, 130, 124, 1.0),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => setState(() {
                    selectedPhotoType = 'Invasive';
                  }),
                  child: AnimatedContainer(
                    duration: Duration(
                        milliseconds: 300), // Adjust the duration as needed
                    curve: Curves
                        .easeInOut, // Adjust the animation curve as needed
                    width: 130,
                    height: 50,
                    decoration: BoxDecoration(
                      color: selectedPhotoType == 'Invasive'
                          ? Color.fromRGBO(121, 199, 115, 1.0)
                          : Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Center(
                      child: Text(
                        'Invasive',
                        style: TextStyle(
                          color: selectedPhotoType == 'Invasive'
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    selectedPhotoType = 'Non-Invasive';
                  }),
                  child: AnimatedContainer(
                    duration: Duration(
                        milliseconds: 300), // Adjust the duration as needed
                    curve: Curves
                        .easeInOut, // Adjust the animation curve as needed
                    width: 130,
                    height: 50,
                    decoration: BoxDecoration(
                      color: selectedPhotoType == 'Non-Invasive'
                          ? Color.fromRGBO(121, 199, 115, 1.0)
                          : Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Center(
                      child: Text(
                        'Non-Invasive',
                        style: TextStyle(
                          color: selectedPhotoType == 'Non-Invasive'
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust the number of columns as needed
                childAspectRatio: 1, // Adjust the aspect ratio if needed
              ),
              itemCount: savedSpeciesPhotoUrls[selectedPhotoType == 'Invasive'
                          ? 'savedInvasiveSpeciePhotoUrls'
                          : 'savedNonInvasiveSpeciePhotoUrls']
                      ?.length ??
                  0,
              itemBuilder: (context, index) {
                var imageList = selectedPhotoType == 'Invasive'
                    ? savedSpeciesPhotoUrls['savedInvasiveSpeciePhotoUrls']
                    : savedSpeciesPhotoUrls['savedNonInvasiveSpeciePhotoUrls'];
                var image = imageList?[index];
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              InvasiveSpecieSpottingDetailsScreen(
                                  markerId: 'test',
                                  userId: auth.currentUser!.uid)),
                    )
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
