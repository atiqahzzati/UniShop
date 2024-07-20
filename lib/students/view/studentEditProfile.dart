import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentEditProfile extends StatefulWidget {
  @override
  _StudentEditProfileState createState() => _StudentEditProfileState();
}

class _StudentEditProfileState extends State<StudentEditProfile> {
  final User user = FirebaseAuth.instance.currentUser!;
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _icNumberController = TextEditingController();
  TextEditingController _bankAccountController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _universityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch user data and set it to the text controllers
    FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> userData = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _fullNameController.text = userData['fullName'];
          _emailController.text = userData['email'];
          _phoneNumberController.text = userData['phoneNumber'];
          _icNumberController.text = userData['icNumber'];
          _bankAccountController.text = userData['bankAccount'];
          _addressController.text = userData['address'];
          _universityController.text = userData['university'];
        });
      }
    });
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
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

  bool _validateInput() {
    String fullName = _fullNameController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();
    String icNumber = _icNumberController.text.trim();
    String bankAccount = _bankAccountController.text.trim();
    String university = _universityController.text.trim();

    if (RegExp(r'[0-9]').hasMatch(fullName)) {
      _showDialog(context, "Error", "Full name cannot have numbers in it.");
      return false;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      _showDialog(context, "Error", "Phone number must be in numbers.");
      return false;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(icNumber)) {
      _showDialog(context, "Error", "IC number must be in numbers.");
      return false;
    }
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(bankAccount)) {
      _showDialog(context, "Error", "Bank account cannot have symbols in it.");
      return false;
    }
    if (RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]').hasMatch(university)) {
      _showDialog(context, "Error", "University cannot have numbers or symbols in it.");
      return false;
    }

    return true;
  }

  void _saveProfile() {
    if (_validateInput()) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'icNumber': _icNumberController.text.trim(),
        'bankAccount': _bankAccountController.text.trim(),
        'address': _addressController.text.trim(),
        'university': _universityController.text.trim(),
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile: $error')));
      });
    }
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
          'Edit Profile',
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
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('Full Name', _fullNameController, Icons.person),
                  SizedBox(height: 16.0),
                  _buildTextField('Email', _emailController, Icons.email),
                  SizedBox(height: 16.0),
                  _buildTextField('Phone Number', _phoneNumberController, Icons.phone, keyboardType: TextInputType.phone),
                  SizedBox(height: 16.0),
                  _buildTextField('IC Number', _icNumberController, Icons.credit_card, keyboardType: TextInputType.number),
                  SizedBox(height: 16.0),
                  _buildTextField('Bank Account', _bankAccountController, Icons.account_balance, keyboardType: TextInputType.number),
                  SizedBox(height: 16.0),
                  _buildTextField('Address', _addressController, Icons.home),
                  SizedBox(height: 16.0),
                  _buildTextField('University', _universityController, Icons.school),
                  SizedBox(height: 20.0),
                  Center(
                    child: Wrap(
                      spacing: 10.0, // Space between buttons
                      runSpacing: 10.0, // Space between rows of buttons
                      children: [
                        ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                          child: Text(
                            'Save Changes',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
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
    );
  }
}
