import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentReviewTutoring extends StatefulWidget {
  @override
  _StudentReviewTutoringState createState() => _StudentReviewTutoringState();
}

class _StudentReviewTutoringState extends State<StudentReviewTutoring> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Tutoring Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('tutoringDetails').doc('tutors').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                // Retrieve data from snapshot
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                String fullName = data['fullName'];
                String subject = data['subject'];
                String hoursAvailable = data['hoursAvailable'];
                String chargePerHour = data['chargePerHour'];

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Full Name of Tutor: $fullName'),
                      Text('Subject for Tutoring: $subject'),
                      Text('Hours Available to Tutor: $hoursAvailable'),
                      Text('Charge per Hour: $chargePerHour'),
                    ],
                  ),
                );
              } else {
                return Center(child: Text('No data found'));
              }
            }
          }
        },
      ),
    );
  }
}
