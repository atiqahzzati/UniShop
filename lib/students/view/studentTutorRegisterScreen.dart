import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/students/view/studentEditTutorRegisterScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class studentTutorRegisterScreen extends StatefulWidget {
  @override
  _studentTutorRegisterScreenState createState() => _studentTutorRegisterScreenState();
}

class _studentTutorRegisterScreenState extends State<studentTutorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _educationLevelController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final List<TextEditingController> _experienceControllers = [];
  final List<TextEditingController> _skillControllers = [];
  File? _verificationLetter;
  File? _resume;
  final ImagePicker _picker = ImagePicker();

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
          'Tutor Registration',
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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    _buildTextField('Full Name', _nameController, Icons.person),
                    _buildTextField('Education Level', _educationLevelController, Icons.school),
                    _buildTextField('Course', _courseController, Icons.book),
                    SizedBox(height: 20),
                    Text(
                      'Experience',
                      style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _experienceControllers.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: _buildTextField('Experience ${index + 1}', _experienceControllers[index], Icons.work),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _experienceControllers.removeAt(index);
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _experienceControllers.add(TextEditingController());
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Text('Add Experience', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Skills',
                      style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _skillControllers.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: _buildTextField('Skill ${index + 1}', _skillControllers[index], Icons.star),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _skillControllers.removeAt(index);
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _skillControllers.add(TextEditingController());
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Text('Add Skill', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 20),
                    _buildFilePicker('Upload Verification Letter: ', _pickVerificationLetter),
                    SizedBox(height: 20),
                    _buildFilePicker('Upload Resume: ', _pickResume),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _registerTutor();
                          } else {
                            _showErrorMessage('You are required to fill in all the forms. Please register again.');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Register',
                          style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(icon, color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
        ),
        style: TextStyle(color: Colors.white),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildFilePicker(String label, VoidCallback onPressed) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
          child: Text('Choose File', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Future<void> _pickVerificationLetter() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _verificationLetter = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickResume() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _resume = File(pickedFile.path);
      });
    }
  }

  void _registerTutor() async {
    // Show loading indicator
    _showLoadingDialog();

    try {
      String? verificationLetterUrl;
      if (_verificationLetter != null) {
        verificationLetterUrl = await _uploadFile(_verificationLetter!, 'verification_letters');
      }

      String? resumeUrl;
      if (_resume != null) {
        resumeUrl = await _uploadFile(_resume!, 'resumes');
      }

      final docRef = await FirebaseFirestore.instance.collection('tutors').add({
        'name': _nameController.text,
        'education_level': _educationLevelController.text,
        'course': _courseController.text,
        'experience': _experienceControllers.map((controller) => controller.text).toList(),
        'skills': _skillControllers.map((controller) => controller.text).toList(),
        'verification_letter_url': verificationLetterUrl,
        'resume_url': resumeUrl,
      });

      // Hide loading indicator
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tutor registered successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to studentEditTutorScreen when tutor is successfully registered
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StudentEditTutorRegisterScreen(
          name: _nameController.text,
          educationLevel: _educationLevelController.text,
          course: _courseController.text,
          experienceControllers: _experienceControllers,
          skillControllers: _skillControllers,
          verificationLetter: _verificationLetter,
          docId: docRef.id, 
          resume: _resume, // Pass the document ID of the newly added tutor
        )),
      );
    } catch (error) {
      // Hide loading indicator
      Navigator.of(context).pop();

      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error registering tutor. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Registering Tutor..."),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _uploadFile(File file, String folder) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      final reference = FirebaseStorage.instance.ref().child(folder).child(file.path);

      // Upload the file to Firebase Storage
      final uploadTask = await reference.putFile(file);

      // Get the download URL from the uploaded file
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (error) {
      print('Error uploading file: $error');
      return null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _educationLevelController.dispose();
    _courseController.dispose();
    for (var controller in _experienceControllers) {
      controller.dispose();
    }
    for (var controller in _skillControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
