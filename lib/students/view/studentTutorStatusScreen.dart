import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/students/models/tutor_model.dart';
import 'package:fluttercalendar_app/students/view/studentRequestTutorScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentTutorStatusScreen extends StatelessWidget {
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
          'Tutor List',
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
                colors: [Color.fromARGB(255, 69, 7, 63), Color.fromARGB(255, 224, 120, 47)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('tutoringDetails').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Tutor> tutors = snapshot.data!.docs.map((DocumentSnapshot doc) {
                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                  return Tutor(
                    id: doc.id,
                    fullName: data['fullName'] ?? '',
                    subject: data['subject'] ?? '',
                    dateAvailability: data['dateAvailability'] as String?,
                    hoursAvailability: data['hoursAvailability'] as String?,
                    chargePerHour: (data['chargePerHour'] ?? 0.0) as double,
                    googleMeetLink: data['googleMeetLink'] ?? '',
                    status: data['status'] ?? '',
                  );
                }).toList();

                if (tutors.isEmpty) {
                  return Center(
                    child: Text(
                      'No tutors available at the moment.',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: tutors.length,
                  itemBuilder: (context, index) {
                    Tutor tutor = tutors[index];
                    return GestureDetector(
                      onTap: () {
                        if (tutor.id.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => studentRequestTutorScreen(selectedTutorId: tutor.id),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Invalid tutor ID'),
                          ));
                        }
                      },
                      child: Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF232526), Color(0xFF414345)],
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
                              Row(
                                children: [
                                  Icon(Icons.person, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    tutor.fullName,
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Subject: ${tutor.subject}',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Date Availability: ${tutor.dateAvailability}',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Hours Availability: ${tutor.hoursAvailability}',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Charge per Hour: \RM${tutor.chargePerHour.toStringAsFixed(2)}',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Google Meet Link: ${tutor.googleMeetLink}',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 16),
                              _buildStatusButton(tutor.status),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String status) {
    Color buttonColor;
    String buttonText;

    switch (status) {
      case 'Pending':
        buttonColor = Colors.yellow;
        buttonText = 'Pending';
        break;
         case 'Rejected':
        buttonColor = Colors.blueAccent;
        buttonText = 'Available';
        break;
      case 'Approved':
        buttonColor = Colors.green;
        buttonText = 'Approved';
        break;
      case 'Rejected':
        buttonColor = Colors.red;
        buttonText = 'Rejected';
        break;
      default:
        buttonColor = Colors.grey;
        buttonText = 'Unknown';
    }

    return ElevatedButton(
      onPressed: () {
        // Add functionality for the status button
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        buttonText,
        style: GoogleFonts.dmSans(color: Colors.white),
      ),
    );
  }
}
