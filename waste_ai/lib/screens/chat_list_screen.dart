import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_ai/screens/chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, String>> chats = [];
  late Future<List<Map<String, String>>> _fetchingChats;

  String searchQuery = '';

  Future<List<Map<String, String>>> getUsersChats() async {
    List<String> chatReceiverIds = [];
    // Fetch the chat documents from the ChatList subcollection
    QuerySnapshot chatListReceiverIdSnapshot = await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('ChatList')
        .get();

    // Iterate through each chat document and extract the receiver_id field
    for (var doc in chatListReceiverIdSnapshot.docs) {
      String? receiverId = doc['receiver_id'] as String?;
      if (receiverId != null) {
        chatReceiverIds.add(receiverId);
      }
    }

    List<Map<String, String>> retrievedChats = [];

    for (var receiverId in chatReceiverIds) {
      // Fetch the user document for the receiver
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(receiverId).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        // Extract the name and profile picture fields
        String name = userData['name'] ?? '';
        String profilePicture = userData['profile_picture'] ?? '';

        // Add the details to the receiverDetails list
        retrievedChats.add({
          'receiverId': receiverId,
          'name': name,
          'profile_picture': profilePicture,
        });
      }
    }

    chats = retrievedChats;

    print(chats);
    return retrievedChats;
  }

  @override
  void initState() {
    super.initState();

    _fetchingChats = getUsersChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Color.fromRGBO(44, 130, 124, 1.0),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, String>>>(
                future: _fetchingChats, // Call the function that fetches chats
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<Map<String, String>> chats = snapshot.data!;
                    return ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        if (chats[index]['name']!
                                .toLowerCase()
                                .contains(searchQuery) ||
                            chats[index]['name']!
                                .toLowerCase()
                                .contains(searchQuery)) {
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(
                                  chats[index]['profile_picture']!),
                            ),
                            title: Text(chats[index]['name']!),
                            subtitle: Text(chats[index]['name']!),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    receiverId: chats[index][
                                        'receiverId']!, // Replace 'test' with actual receiverId
                                    // other parameters if needed
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  } else {
                    return Center(child: Text('No chats found'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
