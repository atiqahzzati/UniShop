import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            final List<DocumentSnapshot> messages = snapshot.data!.docs;

            // Group messages by sender and receiver
            final Map<String, Map<String, dynamic>> groupedMessages = {};
            messages.forEach((message) {
              final senderId = message['senderId'];
              final receiverId = message['receiverId'];
              final key = '$senderId-$receiverId';
              if (!groupedMessages.containsKey(key) ||
                  (message['timestamp'] as Timestamp).compareTo(groupedMessages[key]!['timestamp'] as Timestamp) > 0) {
                groupedMessages[key] = message.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
              }
            });

            // Convert grouped messages map to list
            final List<Map<String, dynamic>> messageList = groupedMessages.values.toList();

            return ListView.builder(
              itemCount: messageList.length,
              itemBuilder: (context, index) {
                final message = messageList[index];
                final senderId = message['senderId'];
                final receiverId = message['receiverId'];
                final latestMessage = message['message'];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageDetailScreen(
                          senderId: senderId,
                          receiverId: receiverId,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: FutureBuilder(
                        future: getUserInfo(senderId),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text('Loading...');
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            var data = snapshot.data!.data() as Map<String, dynamic>;
                            return Text(
                              'Sender: ${data['fullName'] ?? 'Unknown'}',
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            );
                          } else {
                            return Text('Unknown');
                          }
                        },
                      ),
                      subtitle: FutureBuilder(
                        future: getUserInfo(receiverId),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text('Loading...');
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (snapshot.hasData && snapshot.data != null) {
                            var data = snapshot.data!.data() as Map<String, dynamic>;
                            return Text(
                              'Receiver: ${data['fullName'] ?? 'Unknown'}',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            );
                          } else {
                            return Text('Unknown');
                          }
                        },
                      ),
                      trailing: Text(
                        latestMessage,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<DocumentSnapshot> getUserInfo(String userId) async {
    return await FirebaseFirestore.instance.collection('users').doc(userId).get();
  }
}

class MessageDetailScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;

  const MessageDetailScreen({
    Key? key,
    required this.senderId,
    required this.receiverId,
  }) : super(key: key);

  @override
  _MessageDetailScreenState createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
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
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.senderId)
                  .collection('messages')
                  .where('receiverId', isEqualTo: widget.receiverId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError                ) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  List<DocumentSnapshot> messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final messageText = message['message'];
                      final senderId = message['senderId'];
                      final isCurrentUser = senderId == FirebaseAuth.instance.currentUser!.uid;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: Align(
                          alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isCurrentUser ? Colors.blueAccent : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                  future: getUserInfo(senderId),
                                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text('Loading...');
                                    }
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    if (snapshot.hasData && snapshot.data != null) {
                                      var data = snapshot.data!.data() as Map<String, dynamic>;
                                      final fullName = data['fullName'] ?? 'Unknown';
                                      final senderName = isCurrentUser ? 'You' : fullName;
                                      return Text(
                                        senderName,
                                        style: GoogleFonts.dmSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: isCurrentUser ? Colors.white : Colors.black87,
                                        ),
                                      );
                                    } else {
                                      return Text('Unknown');
                                    }
                                  },
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  messageText,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 14,
                                    color: isCurrentUser ? Colors.white : Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  DateFormat('hh:mm a').format((message['timestamp'] as Timestamp).toDate()), // Format timestamp
                                  style: TextStyle(
                                    color: isCurrentUser ? Colors.white70 : Colors.black54,
                                    fontSize: 12,
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
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    sendMessage(_messageController.text);
                    _messageController.clear();
                  },
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.senderId)
        .collection('messages')
        .add({
      'senderId': FirebaseAuth.instance.currentUser!.uid,
      'receiverId': widget.receiverId,
      'message': message,
      'timestamp': Timestamp.now(),
    });
  }

  Future<DocumentSnapshot> getUserInfo(String userId) async {
    return await FirebaseFirestore.instance.collection('users').doc(userId).get();
  }
}

