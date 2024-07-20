import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/students/view/studentEditTutorRegisterScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class Tutor {
  final String docId; // Document ID of the tutor in Firestore
  final String name;
  final String educationLevel;
  final String course;
  final List<String> experience;
  final List<String> skills;
  final String? verificationLetterUrl;
  final String? resumeUrl;

  Tutor({
    required this.docId,
    required this.name,
    required this.educationLevel,
    required this.course,
    required this.experience,
    required this.skills,
    this.verificationLetterUrl,
    this.resumeUrl,
  });
}

class studentTutorRegisterListScreen extends StatelessWidget {
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
          'Registered Tutors',
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('tutors').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final tutors = snapshot.data?.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return Tutor(
                      docId: doc.id, // Assign the document ID
                      name: data['name'],
                      educationLevel: data['education_level'],
                      course: data['course'],
                      experience: List<String>.from(data['experience']),
                      skills: List<String>.from(data['skills']),
                      verificationLetterUrl: data['verification_letter_url'],
                      resumeUrl: data['resume_url'],
                    );
                  }).toList();

                  if (tutors != null && tutors.isNotEmpty) {
                    return ListView.builder(
                      itemCount: tutors.length,
                      itemBuilder: (context, index) {
                        final tutor = tutors[index];
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color.fromARGB(255, 69, 7, 63), Color.fromARGB(255, 224, 120, 47)],
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
                            child: ListTile(
                              leading: tutor.verificationLetterUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        tutor.verificationLetterUrl!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(Icons.image_not_supported, color: Colors.white), // Placeholder icon if URL is not available
                              title: Text(
                                tutor.name,
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Education Level: ${tutor.educationLevel}',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'Course: ${tutor.course}',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'Experience: ${tutor.experience.join(', ')}',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'Skills: ${tutor.skills.join(', ')}',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  if (tutor.resumeUrl != null)
                                    Text(
                                      'Resume Available',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentEditTutorRegisterScreen(
                                      name: tutor.name,
                                      educationLevel: tutor.educationLevel,
                                      course: tutor.course,
                                      experienceControllers: tutor.experience
                                          .map((exp) => TextEditingController(text: exp))
                                          .toList(),
                                      skillControllers: tutor.skills
                                          .map((skill) => TextEditingController(text: skill))
                                          .toList(),
                                      verificationLetter: null,
                                      resume: null,
                                      docId: tutor.docId, // Provide the docId
                                    ),
                                  ),
                                );
                              },
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.white),
                                onPressed: () {
                                  _deleteTutor(context, tutor); // Call delete function
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        'No tutors found',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTutor(BuildContext context, Tutor tutor) async {
    try {
      await FirebaseFirestore.instance.collection('tutors').doc(tutor.docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tutor deleted successfully')),
      );
    } catch (e) {
      print('Error deleting tutor: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete tutor')),
      );
    }
  }
}
