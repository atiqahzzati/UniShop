import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/students/view/studentLoginScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fem = 1.0; // Assuming fem is a dynamic value for scaling

    TextEditingController fullNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController icNumberController = TextEditingController();
    TextEditingController bankAccountController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController universityController = TextEditingController();

    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Function to show dialog
    void _showDialog(BuildContext context, String title, String message, VoidCallback onOkPressed) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: onOkPressed,
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }

    // Function to validate input
    bool _validateInput(BuildContext context) {
      String fullName = fullNameController.text.trim();
      String phoneNumber = phoneNumberController.text.trim();
      String icNumber = icNumberController.text.trim();
      String bankAccount = bankAccountController.text.trim();
      String university = universityController.text.trim();

      if (RegExp(r'[0-9]').hasMatch(fullName)) {
        _showDialog(context, "Error", "Full name cannot have numbers in it.", () {
          Navigator.of(context).pop();
        });
        return false;
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
        _showDialog(context, "Error", "Phone number must be in numbers.", () {
          Navigator.of(context).pop();
        });
        return false;
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(icNumber)) {
        _showDialog(context, "Error", "IC number must be in numbers.", () {
          Navigator.of(context).pop();
        });
        return false;
      }
      if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(bankAccount)) {
        _showDialog(context, "Error", "Bank account cannot have symbols in it.", () {
          Navigator.of(context).pop();
        });
        return false;
      }
      if (RegExp(r'[0-9!@#$%^&*(),.?":{}|<>]').hasMatch(university)) {
        _showDialog(context, "Error", "University cannot have numbers or symbols in it.", () {
          Navigator.of(context).pop();
        });
        return false;
      }

      return true;
    }

    // Function to register user
    Future<void> _registerUser(BuildContext context) async {
      // Check if any field is empty
      if (fullNameController.text.trim().isEmpty ||
          emailController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty ||
          confirmPasswordController.text.trim().isEmpty ||
          phoneNumberController.text.trim().isEmpty ||
          icNumberController.text.trim().isEmpty ||
          bankAccountController.text.trim().isEmpty ||
          addressController.text.trim().isEmpty ||
          universityController.text.trim().isEmpty) {
        _showDialog(context, "Error", "You are required to fill in the form", () {
          Navigator.of(context).pop();
        });
        return;
      }

      // Validate input
      if (!_validateInput(context)) {
        return;
      }

      try {
        // Create user using Firebase Authentication
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Get the user ID
        String userId = userCredential.user!.uid;

        // Store additional user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'fullName': fullNameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'confirmPassword': confirmPasswordController.text.trim(),
          'phoneNumber': phoneNumberController.text.trim(),
          'icNumber': icNumberController.text.trim(),
          'bankAccount': bankAccountController.text.trim(),
          'address': addressController.text.trim(),
          'university': universityController.text.trim(),
        });

        // Show success message and navigate to login page
        _showDialog(context, "Success", "Registration successful", () {
          Navigator.of(context).pop(); // Close the dialog
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StudentLoginPage()),
          );
        });
      } catch (error) {
        // Handle registration errors
        print("Registration error: $error");
        // Display an error message to the user
        _showDialog(context, "Error", "Failed to register. Please try again.", () {
          Navigator.of(context).pop();
        });
      }
    }

    return Scaffold(
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
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20 * fem, vertical: 20 * fem),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Image.asset(
                      'assets/unishop_logo.png', // Ensure this path is correct
                      height: 150 * fem, // Enlarged logo
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.only(bottom: 20 * fem),
                      child: Text(
                        'Register Account',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          height: 1.3025,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.only(bottom: 20 * fem),
                      child: Text(
                        'Enter your information to register your account',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.7857142857,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 30 * fem),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20 * fem),
                            decoration: BoxDecoration(
                              color: Color(0xfffafafa),
                              borderRadius: BorderRadius.circular(10 * fem),
                            ),
                            child: TextField(
                              controller: fullNameController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15 * fem),
                                hintText: 'Full Name',
                                hintStyle: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2857142857,
                                  color: Color(0xffc4c5c4),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20 * fem),
                            decoration: BoxDecoration(
                              color: Color(0xfffafafa),
                              borderRadius: BorderRadius.circular(10 * fem),
                            ),
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15 * fem),
                                hintText: 'Email',
                                hintStyle: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2857142857,
                                  color: Color(0xffc4c5c4),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20 * fem),
                            decoration: BoxDecoration(
                              color: Color(0xfffafafa),
                              borderRadius: BorderRadius.circular(10 * fem),
                            ),
                            child: TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15 * fem),
                                hintText: 'Password',
                                hintStyle: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2857142857,
                                  color: Color(0xffc4c5c4),
                                ),
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20 * fem),
                            decoration: BoxDecoration(
                              color: Color(0xfffafafa),
                              borderRadius: BorderRadius.circular(10 * fem),
                            ),
                            child: TextField(
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15 * fem),
                                hintText: 'Confirm Password',
                                hintStyle: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2857142857,
                                  color: Color(0xffc4c5c4),
                                ),
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20 * fem),
                            decoration: BoxDecoration(
                              color: Color(0xfffafafa),
                              borderRadius: BorderRadius.circular(10 * fem),
                            ),
                            child: TextField(
                              controller: phoneNumberController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15 * fem),
                                hintText: 'Phone Number',
                                hintStyle: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2857142857,
                                  color: Color(0xffc4c5c4),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20 * fem),
                            decoration: BoxDecoration(
                              color: Color(0xfffafafa),
                              borderRadius: BorderRadius.circular(10 * fem),
                            ),
                            child: TextField(
                              controller: icNumberController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15 * fem),
                                hintText: 'IC Number',
                                hintStyle: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2857142857,
                                  color: Color(0xffc4c5c4),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20 * fem),
                            decoration: BoxDecoration(
                              color: Color(0xfffafafa),
                              borderRadius: BorderRadius.circular(10 * fem),
                            ),
                            child: TextField(
                              controller: bankAccountController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15 * fem),
                                hintText: 'Bank Account',
                                hintStyle: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2857142857,
                                  color: Color(0xffc4c5c4),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20 * fem),
                            decoration: BoxDecoration(
                              color: Color(0xfffafafa),
                              borderRadius: BorderRadius.circular(10 * fem),
                            ),
                            child: TextField(
                              controller: addressController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15 * fem),
                                hintText: 'Address',
                                hintStyle: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2857142857,
                                  color: Color(0xffc4c5c4),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20 * fem),
                            decoration: BoxDecoration(
                              color: Color(0xfffafafa),
                              borderRadius: BorderRadius.circular(10 * fem),
                            ),
                            child: TextField(
                              controller: universityController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 15 * fem),
                                hintText: 'University',
                                hintStyle: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2857142857,
                                  color: Color(0xffc4c5c4),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 30 * fem),
                      width: double.infinity,
                      height: 50 * fem,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color.fromARGB(255, 58, 183, 255), Color(0xFF135073).withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10 * fem),
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
                        onPressed: () => _registerUser(context),
                        child: Center(
                          child: Text(
                            'Register',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.4285714286,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(6 * fem, 0 * fem, 5 * fem, 0 * fem),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Have an account?',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.3025,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => StudentLoginPage()),
                              );
                            },
                            child: Text(
                              'Log In',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.3025,
                                color: Color.fromARGB(255, 0, 153, 255),
                              ),
                            ),
                          ),
                        ],
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
}
