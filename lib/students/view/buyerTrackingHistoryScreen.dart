import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyerTrackingHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tracking History',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 199, 178, 142),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('trackingItems').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No tracking items available'));
          } else {
            final trackingItems = snapshot.data!.docs;

            return ListView.builder(
              itemCount: trackingItems.length,
              itemBuilder: (context, index) {
                final item = trackingItems[index];
                final itemName = item['itemName'];
                final trackingNo = item['trackingNo'];
                final status = item['status'];
                final timestamp = item['timestamp'] as Timestamp?;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(itemName),
                    subtitle: Text('Tracking No: $trackingNo\nStatus: $status'),
                    trailing: Text(timestamp != null ? timestamp.toDate().toString() : 'No date'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
