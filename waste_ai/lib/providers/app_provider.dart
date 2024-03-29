import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:waste_ai/screens/camera_screen.dart';
import 'package:waste_ai/screens/chat_list_screen.dart';
import 'package:waste_ai/screens/home_screen.dart';
import 'package:waste_ai/screens/login_screen.dart';
import 'package:waste_ai/screens/map_screen.dart';
import 'package:waste_ai/screens/profile_screen.dart';
import 'package:waste_ai/screens/saved_photos_screen.dart';
import 'package:waste_ai/screens/sign_up_1_screen.dart';
import 'package:waste_ai/screens/sign_up_2_screen.dart';
import 'package:waste_ai/screens/sign_up_screen.dart';

class AppProvider with ChangeNotifier {
  String userId = '';
  String name = '';
  String email = '';
  String password = '';
  String profilePictureUrl = '';
  int level = 1;
  int experience = 0;
  int selectedIndex = 0;
  int userJournalingStreak = 0;
  int totalCatches = 0;
  List<dynamic> badges = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool isUserSignedIn = false;

  void updateName(String name) {
    this.name = name;
    notifyListeners();
  }

  updateEmail(String title) {
    this.email = title;
    notifyListeners();
  }

  updatePassword(String title) {
    password = title;
    notifyListeners();
  }

  void updateLevel(int level) {
    this.level = level;
    notifyListeners();
  }

  Future<void> getBadges() async {
    // Fetch the user's document
    DocumentSnapshot<Map<String, dynamic>> userDocSnapshot =
        await firestore.collection("users").doc(auth.currentUser!.uid).get();

    // Extract the badges list from the document
    List<String> badgesList =
        List<String>.from(userDocSnapshot.data()?['badges'] ?? []);

    // Assign the badges list to the class variable
    this.badges = badgesList;
  }

  void addBadge(String badge) {
    badges.add(badge);
    notifyListeners();
  }

  // int addExperience(int experience) {
  //   this.experience = this.experience + experience;
  //   return this.experience;
  //   notifyListeners();
  // }

  void updateTotalCatches(int totalCatches) {
    this.totalCatches = totalCatches;
    notifyListeners();
  }

  void updateExperience(int experience) {
    this.experience = experience;

    notifyListeners();
  }

  changeSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void onChatBackButtonPressed() {
    selectedIndex = 0;
    notifyListeners();
  }

  void onIconTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<void> checkUserSignedIn() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is signed in
      isUserSignedIn = true;
      // Optional: Print the user's email
      print('User is signed in with email: ${user.email}');
    } else {
      // User is not signed in
      isUserSignedIn = false;
    }

    notifyListeners();
  }

  void setUserInfo(String name, String userId, String profilePictureUrl,
      int level, int experience, int totalCatches, List<dynamic> badges) {
    this.name = name;
    this.userId = userId;
    this.profilePictureUrl = profilePictureUrl;
    this.level = level;
    this.experience = experience;
    this.totalCatches = totalCatches;
    this.badges = badges;

    notifyListeners();
    print('user info has been set!');
  }

  void changeUserSignIn() {
    this.isUserSignedIn = !this.isUserSignedIn;
    // GlobalData.signInCounter -= 1;

    notifyListeners();
  }

  void setProfilePictureUrl(String? profilePictureUrl) {
    if (profilePictureUrl != null) {
      this.profilePictureUrl = profilePictureUrl;
      notifyListeners();
    }
  }

//   Future<void> calculateUserJournalingStreak() async {
//     this.userJournalingStreak = 0;
//     List<dynamic> picturePosts = await fireStorage.getPicturePost(userId);
//     print("hey");
//     List<dynamic> journalPosts = await fireStorage.getAllJournalPost(userId);
//     List<dynamic> notePosts = await fireStorage.getNotePost(userId);

//     List<dynamic> allPostDates = [];
//     allPostDates.addAll(picturePosts);
//     allPostDates.addAll(journalPosts);
//     allPostDates.addAll(notePosts);

//     print(allPostDates);

//     Set<DateTime> dates = {};

//     for (int i = 0; i < allPostDates.length; i++) {
//       dates.add(allPostDates[i].createdAt.toDate());
//     }

//     print(dates);

//     // Convert each date in dates to UTC and normalize to midnight
//     Set<DateTime> datesInUtcMidnight = dates
//         .map((date) => DateTime.utc(date.year, date.month, date.day))
//         .toSet();

// // Initially set 'today' to the current date in UTC at midnight
//     DateTime now = DateTime.now();
//     DateTime today = DateTime.utc(now.year, now.month, now.day);

// // Check if 'today' is not in 'datesInUtcMidnight', then start from yesterday
//     if (!datesInUtcMidnight.contains(today)) {
//       today = today.subtract(Duration(days: 1));
//     }

//     while (datesInUtcMidnight
//         .contains(today.subtract(Duration(days: userJournalingStreak)))) {
//       userJournalingStreak++;
//     }
//     notifyListeners();
//   }

  List<Widget> signedInWidgetOptions() {
    return [
      HomeScreen(),
      SavedPhotosScreen(),
      CameraScreen(),
      MapScreen(),
      ChatListScreen()

      // ChatScreen(
      //     pushedToStack: false,
      //     minheight: Device.screenHeight * 0.4,
      //     maxheight: Device.screenHeight * 0.72),
      // CalendarScreen(),
      // ProfileScreen(
      //     switchScreen: changeSelectedIndex,
      //     checkUserSignedIn: checkUserSignedIn),
      // ProfileScreen(
      //     switchScreen: _switchScreen, checkUserSignedIn: _checkUserSignedIn)
    ];
  }

  List<Widget> signedOutWidgetOptions() {
    return [
      LoginScreen(),
      SignUp1Screen(),
      SignUp2Screen(checkUserSignedIn: checkUserSignedIn),

      // SignUpScreen(),

      // Welcome_screen(
      //     checkUserSignedIn: checkUserSignedIn,
      //     switchScreen: changeSelectedIndex),
      // log_in_1(
      //     checkUserSignedIn: checkUserSignedIn,
      //     switchScreen: changeSelectedIndex),
      // Sign_up_Screen_1(
      //     checkUserSignedIn: checkUserSignedIn,
      //     switchScreen: changeSelectedIndex),
      // Sign_up_Screen_2(
      //     checkUserSignedIn: checkUserSignedIn,
      //     switchScreen: changeSelectedIndex),
      // Sign_up_screen_3(
      //     checkUserSignedIn: checkUserSignedIn,
      //     switchScreen: changeSelectedIndex),
      // log_in_2(
      //     checkUserSignedIn: checkUserSignedIn,
      //     switchScreen: changeSelectedIndex),
      // LoginScreen(
      //     switchScreen: changeSelectedIndex,
      //     checkUserSignedIn: checkUserSignedIn),
      // SignUpScreen(
      //     switchScreen: changeSelectedIndex,
      //     checkUserSignedIn: checkUserSignedIn),
      // VerifyScreen(
      //     switchScreen: changeSelectedIndex,
      //     checkUserSignedIn: checkUserSignedIn)
    ];
  }

  List<Widget> get widgetOptions =>
      isUserSignedIn ? signedInWidgetOptions() : signedOutWidgetOptions();
}
