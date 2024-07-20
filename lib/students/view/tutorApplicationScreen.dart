import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TutorApplicationHistory extends StatefulWidget {
  final String userId;

  TutorApplicationHistory({required this.userId});

  @override
  _TutorApplicationHistoryState createState() => _TutorApplicationHistoryState();
}

class _TutorApplicationHistoryState extends State<TutorApplicationHistory> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _userData;

  @override
  void initState() {
    super.initState();
    _userData = FirebaseFirestore.instance.collection('tutors').doc(widget.userId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Application History'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var data = snapshot.data!.data()!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'Email: ${data['email']}',
                  //   style: TextStyle(fontSize: 18.0),
                  // ),
                  SizedBox(height: 10.0),
                  Text(
                    'Education Level: ${data['educationLevel']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Course Name: ${data['courseName']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 10.0),
                  data.containsKey('imageUrl')
                      ? Image.network(
                          data['imageUrl'],
                          height: 200,
                        )
                      : SizedBox.shrink(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
