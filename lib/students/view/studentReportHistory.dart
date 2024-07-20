import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'studentEditReport.dart'; // Import the studentEditReport.dart file for navigation

class StudentReportHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Report History',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF232526), Color(0xFF414345)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('reports').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final reports = snapshot.data!.docs;
                    if (reports.isEmpty) {
                      return Center(
                        child: Text(
                          'No reports available at the moment.',
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        final data = report.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
                        final itemId = data['itemId'] ?? ''; // Null safe access using '?'
                        final reason = data['reason'] ?? ''; // Null safe access using '?'
                        final status = data['status'] ?? ''; // Null safe access using '?'
                        return GestureDetector(
                          onTap: () {
                            // Navigate to edit report item page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentEditReport(reportId: report.id),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color.fromARGB(255, 75, 13, 114), Color.fromARGB(255, 162, 31, 110)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Item ID: $itemId',
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Reason: $reason',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  // SizedBox(height: 8),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text(
                                  //       'Status: ',
                                  //       style: GoogleFonts.dmSans(
                                  //         fontSize: 16,
                                  //         color: Colors.white70,
                                  //       ),
                                  //     ),
                                  //     ElevatedButton(
                                  //       onPressed: () {}, // Implement action for status button
                                  //       child: Text(status), // Display status on the button
                                  //       style: ElevatedButton.styleFrom(
                                  //         backgroundColor: status == 'Pending'
                                  //             ? Colors.yellow
                                  //             : status == 'Approved'
                                  //                 ? Colors.green
                                  //                 : status == 'Rejected'
                                  //                     ? Colors.red
                                  //                     : Colors.grey,
                                  //         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  //         shape: RoundedRectangleBorder(
                                  //           borderRadius: BorderRadius.circular(10),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
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
          ),
        ],
      ),
    );
  }
}
