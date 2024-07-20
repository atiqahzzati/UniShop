import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/students/models/tutor_model.dart';
import 'package:fluttercalendar_app/students/view/studentTutorPaymentScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class studentRequestTutorScreen extends StatelessWidget {
  final String selectedTutorId;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  studentRequestTutorScreen({Key? key, required this.selectedTutorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Request Tutor',
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
              builder: (context, snapshot) {
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

                if (selectedTutorId.isEmpty) {
                  return Center(child: Text('No tutor selected'));
                }

                Tutor? selectedTutor;
                for (var tutor in tutors) {
                  if (tutor.id == selectedTutorId) {
                    selectedTutor = tutor;
                    break;
                  }
                }

                if (selectedTutor == null) {
                  return const Center(child: Text('Selected tutor not found'));
                }

                return ListView(
                  children: [
                    Card(
                      elevation: 3,
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
                            Text(
                              selectedTutor.fullName,
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Subject: ${selectedTutor.subject}',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Date Availability: ${selectedTutor.dateAvailability}',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Hours Availability: ${selectedTutor.hoursAvailability}',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Charge per Hour: \RM${selectedTutor.chargePerHour.toStringAsFixed(2)}',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            if (selectedTutor.status == 'Approved')
                              Text(
                                'Google Meet Link: ${selectedTutor.googleMeetLink}',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            Text(
                              'Status: ${selectedTutor.status}',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 16),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _requestTutor(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Request Tutor',
                                  style: GoogleFonts.dmSans(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestTutor(BuildContext context) async {
    Tutor? selectedTutor;
    FirebaseFirestore.instance.collection('tutoringDetails').doc(selectedTutorId).get().then((doc) {
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        selectedTutor = Tutor(
          id: doc.id,
          fullName: data['fullName'] ?? '',
          subject: data['subject'] ?? '',
          dateAvailability: data['dateAvailability'] as String?,
          hoursAvailability: data['hoursAvailability'] as String?,
          chargePerHour: (data['chargePerHour'] ?? 0.0) as double,
          googleMeetLink: data['googleMeetLink'] ?? '',
          status: data['status'] ?? '',
        );

        // Check if the selected tutor's status is "Rejected"
        if (selectedTutor!.status == 'Rejected') {
          // Show error message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("The status is: Rejected. You may need to request for another tutor."),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          // Navigate to payment screen
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => studentTutorPaymentScreen(
              onImageSelected: (File image) async {
                // Upload image to Firebase Storage
                String imageUrl = await uploadImage(image);
                // Save image URL to Firestore
                await savePayment(imageUrl, selectedTutorId);
              },
              onSuccess: () {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Your payment is successful!')),
                );
                // Navigate back to studentRequestTutorScreen
                Navigator.of(context).pop();
              },
            ),
          ));
        }
      }
    });
  }

  Future<File?> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      // User canceled the image picking process
      return null;
    }
  }

  Future<String> uploadImage(File image) async {
    Reference ref = FirebaseStorage.instance.ref().child('tutorpayments/${DateTime.now()}');
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> savePayment(String imageUrl, String tutorId) async {
    await FirebaseFirestore.instance.collection('tutor_payments').add({
      'imageUrl': imageUrl,
      'tutorId': tutorId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

