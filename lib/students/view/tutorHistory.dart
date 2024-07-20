import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TutorHistory extends StatefulWidget {
  @override
  _TutorHistoryState createState() => _TutorHistoryState();
}

class _TutorHistoryState extends State<TutorHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutoring History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tutoringDetails').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                // Extract data from the snapshot
                List<DocumentSnapshot> documents = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    // Extract fields from the document
                    String fullName = documents[index].get('fullName') ?? 'N/A';
                    String subject = documents[index].get('subject') ?? 'N/A';
                    String hoursAvailable = documents[index].get('hoursAvailable') ?? 'N/A';
                    String chargePerHour = documents[index].get('chargePerHour') ?? 'N/A';

                    // Display the tutoring details in a ListTile
                    return ListTile(
                      title: Text('Full Name: $fullName'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Subject: $subject'),
                          Text('Hours Available: $hoursAvailable'),
                          Text('Charge Per Hour: $chargePerHour'),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text('No tutoring history found'));
              }
            }
          }
        },
      ),
    );
  }
}
