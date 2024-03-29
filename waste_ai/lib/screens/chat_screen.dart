import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;

  const ChatScreen({Key? key, required this.receiverId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Dummy messages for demonstration

  TextEditingController _sendingMessageController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> messages = [];

  Future<void> getMessagesInChat() async {
    // Find the chat document reference
    DocumentReference? chatDocRef;
    QuerySnapshot chatListSnapshot =
        await firestore.collectionGroup('ChatList').get();

    for (var doc in chatListSnapshot.docs) {
      if ((doc['sender_id'] == auth.currentUser!.uid &&
              doc['receiver_id'] == widget.receiverId) ||
          (doc['sender_id'] == widget.receiverId &&
              doc['receiver_id'] == auth.currentUser!.uid)) {
        chatDocRef = doc.reference;
        break;
      }
    }

    if (chatDocRef != null) {
      // Fetch the messages from the Messages subcollection
      QuerySnapshot messagesSnapshot =
          await chatDocRef.collection('Messages').orderBy('timestamp').get();

      List<Map<String, dynamic>> retrievedMessages = [];
      for (var msgDoc in messagesSnapshot.docs) {
        Map<String, dynamic> messageData =
            msgDoc.data() as Map<String, dynamic>;
        retrievedMessages.add({
          'text': messageData['text'] ?? '',
          'sender': messageData['sender'] ?? '',
          'timestamp': messageData['timestamp'] ?? '',
        });
      }

      setState(() {
        messages = retrievedMessages;
      });
      print(messages);
    }
  }

  Future<void> addMessageToChat() async {
    // Check whether or not chat was already created
    bool chatExists = false;
    DocumentReference? chatDocRef;

    QuerySnapshot chatListSnapshot =
        await firestore.collectionGroup('ChatList').get();

    for (var doc in chatListSnapshot.docs) {
      if ((doc['sender_id'] == auth.currentUser!.uid &&
              doc['receiver_id'] == widget.receiverId) ||
          (doc['sender_id'] == widget.receiverId &&
              doc['receiver_id'] == auth.currentUser!.uid)) {
        // Chat already exists
        chatExists = true;
        chatDocRef =
            doc.reference; // Get the reference to the existing chat document
        break; // Exit the loop once the chat is found
      }
    }

    if (!chatExists) {
      // Chat does not exist, create a new chat document
      chatDocRef = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('ChatList')
          .add({
        'sender': auth.currentUser!.uid,
        'receiver': widget.receiverId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    if (chatDocRef != null) {
      // Add the message to the Messages subcollection of the chat document
      await chatDocRef.collection('Messages').add({
        'text': _sendingMessageController.text,
        'sender': auth.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    setState(() {
      messages.add({
        'text': _sendingMessageController.text,
        'sender': auth.currentUser!.uid
      });
    });

    _sendingMessageController.clear();
  }

  @override
  void initState() {
    super.initState();
    getMessagesInChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverId),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, right: 5, left: 5),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    bool isCurrentUser =
                        messages[index]['sender'] == auth.currentUser!.uid;
                    return Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        margin:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? Color.fromRGBO(97, 157, 92, 1.0)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          messages[index]['text'],
                          style: TextStyle(
                              fontSize: 16,
                              color:
                                  isCurrentUser ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _sendingMessageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(44, 130, 124, 1.0),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Material(
                          // <-- Wrap with Material
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                                15), // <-- same as Container
                            onTap: () async {
                              if (_sendingMessageController.text.isNotEmpty) {
                                //   String text = "";
                                addMessageToChat();
                              }
                            },
                            child: Padding(
                              // <-- Add padding to define the area of the splash
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.send, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
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
