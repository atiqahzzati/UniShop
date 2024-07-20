import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class StudentEditTutorRegisterScreen extends StatefulWidget {
  final String docId; // Document ID of the tutor in Firestore
  final String name;
  final String educationLevel;
  final String course;
  final List<TextEditingController> experienceControllers;
  final List<TextEditingController> skillControllers;
  File? verificationLetter;
  File? resume; // Added resume parameter

  StudentEditTutorRegisterScreen({
    required this.docId,
    required this.name,
    required this.educationLevel,
    required this.course,
    required this.experienceControllers,
    required this.skillControllers,
    this.verificationLetter,
    this.resume, // Added resume parameter
  });

  @override
  _StudentEditTutorRegisterScreenState createState() =>
      _StudentEditTutorRegisterScreenState();
}

class _StudentEditTutorRegisterScreenState
    extends State<StudentEditTutorRegisterScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _educationLevelController;
  late TextEditingController _courseController;
  final ImagePicker _picker = ImagePicker(); // Instantiate ImagePicker here
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _educationLevelController =
        TextEditingController(text: widget.educationLevel);
    _courseController = TextEditingController(text: widget.course);

    // Set initial values for experience and skill controllers
    for (int i = 0; i < widget.experienceControllers.length; i++) {
      widget.experienceControllers[i].text = widget.experienceControllers[i].text;
    }
    for (int i = 0; i < widget.skillControllers.length; i++) {
      widget.skillControllers[i].text = widget.skillControllers[i].text;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _educationLevelController.dispose();
    _courseController.dispose();
    super.dispose();
  }

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
          'Edit Tutor Information',
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
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(Icons.person, color: Colors.white),
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
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _educationLevelController,
                          decoration: InputDecoration(
                            labelText: 'Education Level',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(Icons.school, color: Colors.white),
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
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _courseController,
                          decoration: InputDecoration(
                            labelText: 'Course',
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(Icons.book, color: Colors.white),
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
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Experience',
                          style: GoogleFonts.dmSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.experienceControllers.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: widget.experienceControllers[index],
                                    decoration: InputDecoration(
                                      labelText: 'Experience ${index + 1}',
                                      labelStyle: TextStyle(color: Colors.white),
                                      prefixIcon: Icon(                                        Icons.work, color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.white.withOpacity(0.3)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor:
                                          Colors.white.withOpacity(0.2),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      widget.experienceControllers
                                          .removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.experienceControllers
                                  .add(TextEditingController());
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Add Experience',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Skills',
                          style: GoogleFonts.dmSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.skillControllers.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: widget.skillControllers[index],
                                    decoration: InputDecoration(
                                      labelText: 'Skill ${index + 1}',
                                      labelStyle: TextStyle(color: Colors.white),
                                      prefixIcon: Icon(Icons.star,
                                          color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.white.withOpacity(0.3)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor:
                                          Colors.white.withOpacity(0.2),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      widget.skillControllers.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.skillControllers
                                  .add(TextEditingController());
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Add Skill',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Upload New Verification Letter: ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            ElevatedButton(
                              onPressed: _pickVerificationLetter,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Choose File',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Upload New Resume: ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            ElevatedButton(
                              onPressed: _pickResume,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Choose File',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Wrap(
                            spacing: 10.0, // Space between buttons
                            runSpacing: 10.0, // Space between rows of buttons
                            children: [
                              ElevatedButton(
                                onPressed: _saveTutor,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Save',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _deleteTutor,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); // Cancel operation
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _pickVerificationLetter() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        widget.verificationLetter = File(pickedFile.path);
      });
    }
  }

  void _pickResume() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        widget.resume = File(pickedFile.path);
      });
    }
  }

  void _saveTutor() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _firestore.collection('tutors').doc(widget.docId).update({
        'name': _nameController.text,
        'educationLevel': _educationLevelController.text,
        'course': _courseController.text,
        'experience': widget.experienceControllers.map((e) => e.text).toList(),
        'skills': widget.skillControllers.map((e) => e.text).toList(),
        // Add other fields as needed
      });
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tutor information saved successfully')),
      );
      Navigator.pop(context); // Navigate back after successful save
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save tutor information')),
      );
    }
  }

  void _deleteTutor() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _firestore.collection('tutors').doc(widget.docId).delete();
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context); // Navigate back after successful deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tutor deleted successfully')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete tutor')),
      );
    }
  }
}
