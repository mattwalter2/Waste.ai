import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:waste_ai/screens/bottom_bar.dart';

import 'package:waste_ai/screens/home_screen.dart';
import 'package:waste_ai/providers/app_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  // add a state for user authentication status

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AppProvider>(context, listen: true).checkUserSignedIn();
    });
    // Call the method to check the user's sign-in status
  }

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<AppProvider>(context, listen: true);

    return Scaffold(
        body: Column(
          children: [
            Expanded(
                child: providerData.widgetOptions[providerData.selectedIndex]),
            if (providerData.isUserSignedIn)
              Divider(
                height: 0,
              ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: providerData.isUserSignedIn
            ? FloatingActionButton(
                elevation: 0,
                shape: CircleBorder(),
                backgroundColor: Color.fromRGBO(97, 157, 92, 1.0),
                foregroundColor: Colors.white,
                onPressed: () => providerData.changeSelectedIndex(2),
                child: Icon(
                  FontAwesomeIcons.camera,
                ),
              )
            : null,
        bottomNavigationBar: providerData.isUserSignedIn
            ? BottomAppBar(
                clipBehavior: Clip.antiAlias,
                child: BottomBar(
                  currentIndex: providerData.selectedIndex,
                  onIconTapped: (index) {
                    providerData.changeSelectedIndex(index);
                  },
                ),
              )
            : null);
  }
}
