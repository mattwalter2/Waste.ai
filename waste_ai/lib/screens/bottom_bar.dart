import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onIconTapped;

  const BottomBar({
    super.key,
    required this.currentIndex,
    required this.onIconTapped,
  });

  @override
  Widget build(BuildContext context) {
    // int safeIndex = (currentIndex >= 0 && currentIndex < 4) ? currentIndex : 0;

    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
      ),
      child: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        iconSize: 25,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: Color.fromARGB(255, 59, 66, 78),
        selectedItemColor: Color.fromRGBO(44, 130, 124, 1.0),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        selectedLabelStyle:
            TextStyle(fontSize: 12), // Set your preferred font size
        unselectedLabelStyle: TextStyle(fontSize: 12),

        onTap: onIconTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            // Scale the "Add" icon
            icon: Transform.scale(
                scale: 1, // Choose a suitable scale factor
                child: Icon(
                  Icons.photo_album,
                )),
            label: "Photos",
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).backgroundColor,
            icon: const SizedBox.shrink(),
            label: "",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(FontAwesomeIcons.camera),
          //   label: "Camera",
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(FontAwesomeIcons.solidBookmark),
          //   label: "Bookmark",
          // ),

          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.mapLocation),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidMessage),
            label: "Chat",
          ),
        ],
      ),
    );
  }
}
