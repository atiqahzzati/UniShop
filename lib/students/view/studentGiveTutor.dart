import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentGiveTutor extends StatefulWidget {
  @override
  _StudentGiveTutorState createState() => _StudentGiveTutorState();
}

class _StudentGiveTutorState extends State<StudentGiveTutor> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _hourAvailableController = TextEditingController();
  TextEditingController _chargePerHourController = TextEditingController();
  TextEditingController _googleMeetLinkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Give Tutoring'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name of Tutor'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject for Tutoring'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _hourAvailableController,
              decoration: InputDecoration(labelText: 'Hours Available to Tutor'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _chargePerHourController,
              decoration: InputDecoration(labelText: 'Charge per Hour'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _googleMeetLinkController,
              decoration: InputDecoration(labelText: 'Google Meet Link'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Save the tutoring details
                _saveTutoringDetails();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTutoringDetails() async {
    String fullName = _fullNameController.text.trim();
    String subject = _subjectController.text.trim();
    String hoursAvailable = _hourAvailableController.text.trim();
    String chargePerHour = _chargePerHourController.text.trim();
    String googleMeetLink = _googleMeetLinkController.text.trim();

    // Perform validation if needed

    try {
      // Add tutoring details to Firestore
      await FirebaseFirestore.instance.collection('tutoringDetails').add({
        'fullName': fullName,
        'subject': subject,
        'hoursAvailable': hoursAvailable,
        'chargePerHour': chargePerHour,
        'googleMeetLink': googleMeetLink,
      });

      // Show success message or navigate to another page
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Tutoring details saved successfully!'),
        duration: Duration(seconds: 2),
      ));
    } catch (error) {
      // Handle error
      print('Error saving tutoring details: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save tutoring details. Please try again.'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}