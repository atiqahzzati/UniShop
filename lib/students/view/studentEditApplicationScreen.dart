import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditApplicationScreen extends StatefulWidget {
   final String applicationId;


  EditApplicationScreen({required this.applicationId});

  @override
  _EditApplicationScreenState createState() => _EditApplicationScreenState();
}

class _EditApplicationScreenState extends State<EditApplicationScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _educationLevelController;
  late TextEditingController _courseNameController;
  late TextEditingController _additionalInfoController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _educationLevelController = TextEditingController();
    _courseNameController = TextEditingController();
    _additionalInfoController = TextEditingController();

    // Fetch application details when the page is initialized
    fetchApplicationDetails();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _educationLevelController.dispose();
    _courseNameController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  // Method to fetch application details based on application ID
  void fetchApplicationDetails() async {
    try {
      final DocumentSnapshot applicationSnapshot =
          await FirebaseFirestore.instance.collection('tutor_applications').doc(widget.applicationId).get();

      if (applicationSnapshot.exists) {
        setState(() {
          _fullNameController.text = applicationSnapshot['full_name'];
          _emailController.text = applicationSnapshot['email'];
          _educationLevelController.text = applicationSnapshot['education_level'];
          _courseNameController.text = applicationSnapshot['course_name'];
          _additionalInfoController.text = applicationSnapshot['additional_info'];
        });
      }
    } catch (e) {
      print('Error fetching application details: $e');
    }
  }

  // Method to update application details
  void updateApplication() async {
    try {
      await FirebaseFirestore.instance.collection('tutor_applications').doc(widget.applicationId).update({
        'full_name': _fullNameController.text,
        'email': _emailController.text,
        'education_level': _educationLevelController.text,
        'course_name': _courseNameController.text,
        'additional_info': _additionalInfoController.text,
      });

      // Show a snackbar to indicate success
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Application updated successfully'),
      ));
    } catch (e) {
      print('Error updating application: $e');
      // Show a snackbar to indicate error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update application'),
      ));
    }
  }

  // Method to delete the application
  void deleteApplication() async {
    try {
      await FirebaseFirestore.instance.collection('tutor_applications').doc(widget.applicationId).delete();

      // Navigate back to the previous screen
      Navigator.of(context).pop();
    } catch (e) {
      print('Error deleting application: $e');
      // Show a snackbar to indicate error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete application'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Application'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _educationLevelController,
                decoration: InputDecoration(labelText: 'Education Level'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _courseNameController,
                decoration: InputDecoration(labelText: 'Course Name'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _additionalInfoController,
                decoration: InputDecoration(labelText: 'Additional Information'),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: updateApplication,
                    child: Text('Update'),
                  ),
                  ElevatedButton(
                    onPressed: deleteApplication,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: Text('Delete'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cancel action, navigate back
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
