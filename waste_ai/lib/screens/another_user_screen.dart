import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waste_ai/providers/app_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:waste_ai/screens/settings_screen.dart';

class AnotherUserScreen extends StatefulWidget {
  const AnotherUserScreen({super.key});

  @override
  State<AnotherUserScreen> createState() => _AnotherUserScreenState();
}

class _AnotherUserScreenState extends State<AnotherUserScreen> {
  List<SpecieInfo> species = [
    SpecieInfo('assets/SpottedLaternfly.jpeg', 'jane level 2'),
    // Add two more entries or duplicate the first one for the example
    SpecieInfo('assets/SpottedLaternfly.jpeg', 'jane level 2'),
    SpecieInfo('assets/SpottedLaternfly.jpeg', 'jane level 2'),
  ];
  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<AppProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromRGBO(44, 130, 124, 1.0),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 160,
                    child: Column(
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
                                      fontSize:
                                          20, // You can adjust the font size
                                    ),
                                  ),
                                ),
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
                                        Radius.circular(
                                            10)) // Keep it as a circle
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
                        SizedBox(height: 5),
                        Container(
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
                      ],
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
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Catches',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 30),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          height: 230,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: species.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Container(
                                    width: 200,
                                    height: 200,
                                    margin: EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit
                                            .cover, // This covers the container, cropping if necessary.
                                        image: AssetImage(
                                            species[index].imagePath),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    species[index].name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          height: 100,
                          width: double.infinity,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(show: false),
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
                        SizedBox(
                          height: 230,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: species.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    species[index].name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              );
                            },
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
