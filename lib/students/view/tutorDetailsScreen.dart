import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TutorDetailsScreen extends StatelessWidget {
  final String userId;

  const TutorDetailsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('tutors').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var tutorData = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Email: ${tutorData['email']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Education Level: ${tutorData['educationLevel']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Course Name: ${tutorData['courseName']}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the edit screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TutorEditScreen(userId: userId),
                        ),
                      );
                    },
                    child: Text('Edit'),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // Delete tutor details
                      FirebaseFirestore.instance.collection('tutors').doc(userId).delete();
                      // Navigate back to the previous screen
                      Navigator.pop(context);
                    },
                    child: Text('Delete'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class TutorEditScreen extends StatefulWidget {
  final String userId;

  const TutorEditScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _TutorEditScreenState createState() => _TutorEditScreenState();
}

class _TutorEditScreenState extends State<TutorEditScreen> {
  late TextEditingController _emailController;
  late TextEditingController _educationLevelController;
  late TextEditingController _courseNameController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current data
    FirebaseFirestore.instance.collection('tutors').doc(widget.userId).get().then((doc) {
      var tutorData = doc.data() as Map<String, dynamic>;
      _emailController = TextEditingController(text: tutorData['email']);
      _educationLevelController = TextEditingController(text: tutorData['educationLevel']);
      _courseNameController = TextEditingController(text: tutorData['courseName']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tutor Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _educationLevelController,
              decoration: InputDecoration(labelText: 'Education Level'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _courseNameController,
              decoration: InputDecoration(labelText: 'Course Name'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Update tutor details
                FirebaseFirestore.instance.collection('tutors').doc(widget.userId).update({
                  'email': _emailController.text.trim(),
                  'educationLevel': _educationLevelController.text.trim(),
                  'courseName': _courseNameController.text.trim(),
                });
                // Navigate back to tutor details screen
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Cancel editing and navigate back to tutor details screen
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
