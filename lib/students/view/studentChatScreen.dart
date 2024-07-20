import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StudentChatScreen extends StatefulWidget {
  final String sellerId;

  const StudentChatScreen({Key? key, required this.sellerId}) : super(key: key);

  @override
  _StudentChatScreenState createState() => _StudentChatScreenState();
}

class _StudentChatScreenState extends State<StudentChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _textEditingController = TextEditingController();
  late User _user;
  late String _userId;
  late String _sellerFCMToken; // FCM token of the seller

  @override
  void initState() {
    super.initState();
    _getUser();
    _initializeFirebaseMessaging();
    _retrieveSellerFCMToken();
  }

  void _getUser() {
    _user = _auth.currentUser!;
    _userId = _user.uid;
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message while app is in foreground: ${message.notification?.title}');
      // Handle the incoming message
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.notification?.title}');
    // Handle the message in a background isolate or scheduled task
  }

  void _sendMessage(String messageText) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(_userId) // Use the current user's ID as the document ID
        .collection('messages') // Sub-collection
        .add({
      'senderId': _userId, // Sender is the current user
      'receiverId': widget.sellerId,
      'message': messageText,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _retrieveSellerFCMToken() {
    // Retrieve seller's FCM token from Firestore
    FirebaseFirestore.instance.collection('sellers').doc(widget.sellerId).get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          _sellerFCMToken = snapshot['fcmToken']; // Replace 'fcmToken' with the actual field name
        });
      }
    }).catchError((error) {
      print('Error retrieving seller\'s FCM token: $error');
    });
  }

  Future<String> _getUserName(String userId) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc['fullName'] ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat History',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('chats')
                  .doc(_userId)
                  .collection('messages')
                  .where('receiverId', isEqualTo: widget.sellerId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                } else {
                  List<DocumentSnapshot> messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final messageText = message['message'];
                      final isCurrentUser = message['senderId'] == _userId;
                      final timestamp = message['timestamp'] != null
                          ? (message['timestamp'] as Timestamp).toDate()
                          : DateTime.now();

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Align(
                          alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: isCurrentUser ? Colors.blueAccent : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<String>(
                                  future: _getUserName(message['senderId']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text('Loading...', style: TextStyle(color: isCurrentUser ? Colors.white : Colors.black87));
                                    } else if (snapshot.hasError) {
                                      return Text('Unknown', style: TextStyle(color: isCurrentUser ? Colors.white : Colors.black87));
                                    } else {
                                      return Text(snapshot.data!, style: TextStyle(color: isCurrentUser ? Colors.white : Colors.black87));
                                    }
                                  },
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  messageText,
                                  style: TextStyle(
                                    color: isCurrentUser ? Colors.white : Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  DateFormat('hh:mm a').format(timestamp), // Format timestamp
                                  style: TextStyle(
                                    color: isCurrentUser ? Colors.white70 : Colors.black54,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      String messageText = _textEditingController.text.trim();
                      if (messageText.isNotEmpty) {
                        _sendMessage(messageText);
                        _textEditingController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
