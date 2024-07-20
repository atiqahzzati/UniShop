import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class StudentCreateReport extends StatefulWidget {
  final String itemId;
  final String itemName;
  final String itemPrice;
  final String sellerName;

  StudentCreateReport({
    required this.itemId,
    required this.itemName,
    required this.itemPrice,
    required this.sellerName,
  });

  @override
  _StudentCreateReportState createState() => _StudentCreateReportState();
}

class _StudentCreateReportState extends State<StudentCreateReport> {
  String _selectedReason = 'Wrong Items';
  String _additionalDetails = '';
  File? _image;
  bool _isSubmitting = false;

  final picker = ImagePicker();

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
          'Create Report',
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
                colors: [Color.fromARGB(255, 75, 13, 114), Color.fromARGB(255, 162, 31, 110)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item Information:',
                    style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  _buildTextField('Item ID', widget.itemId, Icons.label, readOnly: true),
                  SizedBox(height: 20),
                  _buildTextField('Item Price', widget.itemPrice, Icons.attach_money, readOnly: true),
                  SizedBox(height: 20),
                  _buildTextField('Seller Name', widget.sellerName, Icons.person, readOnly: true),
                  SizedBox(height: 20),
                  Text(
                    'Reason for Report:',
                    style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  _buildDropdownButton(),
                  SizedBox(height: 20),
                  TextFormField(
                    onChanged: (value) {
                      _additionalDetails = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Additional Details (Optional)',
                      hintStyle: GoogleFonts.dmSans(color: Colors.white70),
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
                    maxLines: null,
                    style: GoogleFonts.dmSans(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  _buildGradientButton('Select Image', _getImage),
                  SizedBox(height: 20),
                  _isSubmitting
                      ? Center(child: CircularProgressIndicator())
                      : _buildGradientButton('Submit', () => _submitReport(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, IconData icon, {bool readOnly = false}) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.dmSans(color: Colors.white),
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
      style: GoogleFonts.dmSans(color: Colors.white),
    );
  }

  Widget _buildDropdownButton() {
    return DropdownButtonFormField<String>(
      value: _selectedReason,
      onChanged: (String? newValue) {
        setState(() {
          _selectedReason = newValue!;
        });
      },
      items: <String>[
        'Wrong Items',
        'Scammed',
        'Scammer',
        'Others',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Select Reason',
        labelStyle: GoogleFonts.dmSans(color: Colors.white),
        prefixIcon: Icon(Icons.warning, color: Colors.white),
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
      dropdownColor: Colors.blueGrey,
      style: GoogleFonts.dmSans(color: Colors.white),
    );
  }

  Widget _buildGradientButton(String text, Function() onPressed) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 0, 162, 255), Color.fromARGB(255, 0, 166, 255)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _submitReport(BuildContext context) async {
  setState(() {
    _isSubmitting = true;
  });

  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // Check if an image has been selected
    if (_image == null) {
      _showErrorDialog(context, "Failed making a report", "Please upload an image for proof.");
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    String? imageUrl;
    if (_image != null) {
      final storageRef = FirebaseStorage.instance.ref().child('reports').child(widget.itemId + '.jpg');
      await storageRef.putFile(_image!);
      imageUrl = await storageRef.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('reports').add({
      'itemId': widget.itemId,
      'itemName': widget.itemName,
      'itemPrice': widget.itemPrice,
      'sellerName': widget.sellerName,
      'reason': _selectedReason,
      'additionalDetails': _additionalDetails,
      'reportedBy': user.uid,
      'reportDate': Timestamp.now(),
      'imageUrl': imageUrl,
    });

    Fluttertoast.showToast(
      msg: "Report submitted successfully! Please wait for the action by admin. Thank you.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    Navigator.of(context).pop();
  }

  setState(() {
    _isSubmitting = false;
  });
}


  void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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
  }

  bool _containsNonNumericCharacters(String input) {
    RegExp regex = RegExp(r'[a-zA-Z!@#$%^&*(),.?":{}|<>]');
    return regex.hasMatch(input);
  }
}

