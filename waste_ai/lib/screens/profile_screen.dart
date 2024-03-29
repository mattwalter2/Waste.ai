import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:waste_ai/providers/app_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:waste_ai/screens/chat_screen.dart';
import 'package:waste_ai/screens/invasive_specie_spotting_details_screen.dart';
import 'package:waste_ai/screens/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userIdBeingViewed;

  const ProfileScreen({super.key, required this.userIdBeingViewed});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<SpecieInfo> species = [
    SpecieInfo('assets/SpottedLaternfly.jpeg', 'jane level 2'),
    // Add two more entries or duplicate the first one for the example
    SpecieInfo('assets/SpottedLaternfly.jpeg', 'jane level 2'),
    SpecieInfo('assets/SpottedLaternfly.jpeg', 'jane level 2'),
  ];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<String> getLastFiveDaysLabels() {
    final now = DateTime.now();
    final formatter =
        DateFormat('MM/dd'); // Format the date as you need, e.g., "MM/dd"
    return List.generate(5, (index) {
      final day = now.subtract(Duration(days: index));
      return formatter.format(day);
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<AppProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: const Color.fromRGBO(44, 130, 124, 1.0),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Stack(
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
                        radius: 80,
                        backgroundImage:
                            NetworkImage(providerData.profilePictureUrl),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          child: Center(
                            child: Text(
                              'Matt',
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontWeight: FontWeight.bold,
                                fontSize: 20, // You can adjust the font size
                              ),
                            ),
                          ),
                          width: 10 * 6,
                          height: 10 * 3,
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
                                  Radius.circular(10)) // Keep it as a circle
                              ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Stack(
                          alignment: Alignment
                              .bottomCenter, // Align the text in the center of the stack
                          children: <Widget>[
                            Image.asset(
                              width: 50, height: 50,
                              'assets/fire-icon-in-gradient-red-colors-flame-signs-illustration-png.webp',
                              // You might want to set the width and height or use BoxFit to determine how the image fills the space.
                            ),
                            Text(
                              '5',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize:
                                    24, // Choose the font size according to your design
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  widget.userIdBeingViewed == auth.currentUser!.uid
                      ? SizedBox
                          .shrink() // Render an empty widget if currentUser is true
                      : SizedBox(height: 5),
                  widget.userIdBeingViewed == auth.currentUser!.uid
                      ? SizedBox
                          .shrink() // Render an empty widget if currentUser is true
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                        receiverId: widget.userIdBeingViewed,
                                      )),
                            );
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                'Message',
                                style: TextStyle(
                                  color: Color.fromRGBO(
                                      44, 130, 124, 1.0), // Text color
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20, // You can adjust the font size
                                ),
                              ),
                            ),
                            height: 10 * 3,
                            decoration: BoxDecoration(
                                // Define the gradient
                                border: Border.all(
                                    width: 2,
                                    color: Color.fromRGBO(44, 130, 124, 1.0)),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10)) // Keep it as a circle
                                ),
                          ),
                        ),
                  Container(
                    height: 50,
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
                            Radius.circular(10)) // Keep it as a circle
                        ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Level ${providerData.level}(${providerData.experience}/500xp)',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: (providerData.experience / 500) *
                                      1, // Represents the 300/500 progress
                                  child: Container(
                                    height: 10,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red,
                                          Colors.orange,
                                          Colors.yellow
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Level ${providerData.level}(${providerData.experience}/500xp)',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 30),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: (265 / 500) *
                                    1, // Represents the 300/500 progress
                                child: Container(
                                  height: 10,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.red,
                                        Colors.orange,
                                        Colors.yellow
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  UserRecentCatchesWidget(
                      userId: 'KVrT7RrDZHS3tw6cCF8Lkz6AuAM2'),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'History of Catches',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 30),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 220,
                          width: double.infinity,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      interval: 1,
                                      getTitlesWidget:
                                          (double value, TitleMeta meta) {
                                        final labels = getLastFiveDaysLabels();
                                        var text = '';
                                        switch (value.toInt()) {
                                          case 0:
                                            text = labels[0];
                                            break;
                                          case 1:
                                            text = labels[1];
                                            break;
                                          case 2:
                                            text = labels[2];
                                            break;
                                          case 3:
                                            text = labels[3];
                                            break;
                                          case 4:
                                            text = labels[4];
                                            break;
                                        }
                                        throw StateError(
                                            'This should never happen!');
                                      }),
                                  axisNameWidget: Text(
                                    'Number of Catches',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles:
                                        true, // Turn on the titles for the x-axis.
                                    // Add your side title configuration for the x-axis here if needed.
                                  ),
                                  axisNameWidget: Padding(
                                    padding: const EdgeInsets.only(
                                        right:
                                            16.0), // Adjust the padding to properly position the x-axis title.
                                    child: Text(
                                      'Day',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                // Configure other axis titles properties if needed.
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 1),
                                    FlSpot(1, 3),
                                    FlSpot(2, 2),
                                    FlSpot(3, 5),
                                    FlSpot(4, 3),
                                    // Add more points here
                                  ],
                                  isCurved: true,
                                  color: Colors.blue,
                                  barWidth: 4,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(show: false),
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Badges',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 30),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 200,
                          child: Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis
                                  .horizontal, // Make the ListView scroll horizontally
                              itemCount: providerData.badges.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 200, // Adjust the width as needed
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(providerData.badges[
                                          index]), // Ensure `image` is a String URL
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SpecieInfo {
  final String imagePath;
  final String name;

  SpecieInfo(this.imagePath, this.name);
}

class UserRecentCatchesWidget extends StatefulWidget {
  final String userId;

  const UserRecentCatchesWidget({Key? key, required this.userId})
      : super(key: key);

  @override
  State<UserRecentCatchesWidget> createState() =>
      _UserRecentCatchesWidgetState();
}

class _UserRecentCatchesWidgetState extends State<UserRecentCatchesWidget> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Future<List<Map<String, dynamic>>> _recentCatchesFuture;

  Future<List<Map<String, dynamic>>> getRecentCatches() async {
    QuerySnapshot snapshot = await firestore
        .collection('users')
        .doc(widget.userId)
        .collection('SavedInvasiveSpecieImages')
        .orderBy('timestamp', descending: true)
        .limit(5)
        .get();

    return snapshot.docs.map((doc) {
      return {
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
    _recentCatchesFuture = getRecentCatches();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Catches',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
        SizedBox(height: 14),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _recentCatchesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<Map<String, dynamic>> catches = snapshot.data!;
              return SizedBox(
                height: 270,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: catches.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InvasiveSpecieSpottingDetailsScreen(
                              userId: widget.userId,
                              markerId: 'test', // Replace with actual markerId
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
                            image: NetworkImage(catches[index]['url']),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Text('No recent catches found');
            }
          },
        ),
      ],
    );
  }
}
