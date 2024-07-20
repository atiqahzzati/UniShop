// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ApplyToBecomeTutorPage extends StatefulWidget {
//   @override
//   _ApplyToBecomeTutorPageState createState() => _ApplyToBecomeTutorPageState();
// }

// class _ApplyToBecomeTutorPageState extends State<ApplyToBecomeTutorPage> {
//   File? _imageFile;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _educationLevelController = TextEditingController();
//   final TextEditingController _courseNameController = TextEditingController();
//   final TextEditingController _additionalInfoController = TextEditingController();

//   Future<void> _getImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   void _submitApplication() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     String imageUrl = '';
//     if (_imageFile != null) {
//       final ref = FirebaseStorage.instance
//           .ref()
//           .child('tutor_application_images')
//           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

//       await ref.putFile(_imageFile!);

//       imageUrl = await ref.getDownloadURL();
//     }

//     await FirebaseFirestore.instance.collection('tutor_applications').add({
//       'full_name': _fullNameController.text,
//       'email': _emailController.text,
//       'education_level': _educationLevelController.text,
//       'course_name': _courseNameController.text,
//       'additional_info': _additionalInfoController.text,
//       'image_url': imageUrl,
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Application Submitted'),
//           content: Text('Your application has been submitted successfully. We will notify you once it is reviewed.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );

//     _fullNameController.clear();
//     _emailController.clear();
//     _educationLevelController.clear();
//     _courseNameController.clear();
//     _additionalInfoController.clear();
//     setState(() {
//       _imageFile = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Apply to Become a Tutor'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Apply to Become a Tutor',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Please fill out the form below to apply to become a tutor:',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(height: 20),
//                 TextFormField(
//                   controller: _fullNameController,
//                   decoration: InputDecoration(labelText: 'Full Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your full name';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: InputDecoration(labelText: 'Email'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   controller: _educationLevelController,
//                   decoration: InputDecoration(labelText: 'Education Level'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your education level';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   controller: _courseNameController,
//                   decoration: InputDecoration(labelText: 'Course Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the course name';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: _getImage,
//                   child: Text('Upload Student Verification Letter'),
//                 ),
//                 SizedBox(height: 10),
//                 _imageFile != null
//                     ? Image.file(
//                         _imageFile!,
//                         height: 150,
//                       )
//                     : SizedBox.shrink(),
//                 TextFormField(
//                   controller: _additionalInfoController,
//                   decoration: InputDecoration(labelText: 'Additional Information'),
//                   maxLines: 3,
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _submitApplication,
//                   child: Text('Submit'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class StudentApplicationHistory extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Application History'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('tutor_applications').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else {
//             final applications = snapshot.data!.docs;
//             if (applications.isEmpty) {
//               return Center(
//                 child: Text('No applications found'),
//               );
//             }
//             return ListView.builder(
//               itemCount: applications.length,
//               itemBuilder: (context, index) {
//                 final application = applications[index];
//                 final imageUrl = application['image_url'];
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   elevation: 4,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Application by ${application['full_name']}',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Email: ${application['email']}',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Education Level: ${application['education_level']}',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Course Name: ${application['course_name']}',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 8),
//                         imageUrl != null
//                             ? Image.network(
//                                 imageUrl,
//                                 height: 150,
//                                 width: 150,
//                                 fit: BoxFit.cover,
//                               )
//                             : SizedBox.shrink(),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
