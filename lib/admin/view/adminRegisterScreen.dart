import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/admin/view/adminLoginPage.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminRegisterScreen extends StatelessWidget {
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

    // Function to register user
    Future<void> _registerUser(BuildContext context) async {
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

        // Navigate to next screen (optional)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminLoginPage()),
        );
      } catch (error) {
        // Handle registration errors
        print("Registration error: $error");
        // Display an error message to the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Registration Error"),
              content: Text("Failed to register. Please try again."),
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
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(33.39 * fem, 14 * fem, 14.5 * fem, 12 * fem),
                width: double.infinity,
                height: 44 * fem,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * fem, 2.16 * fem, 0 * fem, 4.34 * fem),
                      height: 783.3,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                margin: EdgeInsets.fromLTRB(25 * fem, 0 * fem, 0 * fem, 20 * fem),
                constraints: BoxConstraints(maxWidth: 219 * fem),
                child: Text(
                  'Register Account',
                  style: GoogleFonts.dmSans(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    height: 1.3025,
                    color: Color(0xff0c1a30),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25 * fem, 0 * fem, 0 * fem, 0 * fem),
                child: Text(
                  'Enter your information to register your account',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.7857142857,
                    color: Color(0xff838589),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(25 * fem, 50 * fem, 25 * fem, 29 * fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.2857142857,
                          color: Color(0xffc4c5c4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.2857142857,
                          color: Color(0xffc4c5c4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                      ),
                    ),
                     SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.2857142857,
                          color: Color(0xffc4c5c4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                      ),
                    ),
                     SizedBox(height: 20),
                    TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.2857142857,
                          color: Color(0xffc4c5c4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.2857142857,
                          color: Color(0xffc4c5c4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: icNumberController,
                      decoration: InputDecoration(
                        hintText: 'IC Number',
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.2857142857,
                          color: Color(0xffc4c5c4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: bankAccountController,
                      decoration: InputDecoration(
                        hintText: 'Bank Account',
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.2857142857,
                          color: Color(0xffc4c5c4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        hintText: 'Address',
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.2857142857,
                          color: Color(0xffc4c5c4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: universityController,
                      decoration: InputDecoration(
                        hintText: 'University',
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.2857142857,
                          color: Color(0xffc4c5c4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _registerUser(context),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(1 * fem, 0 * fem, 0 * fem, 23 * fem),
                        width: 325 * fem,
                        height: 50 * fem,
                        decoration: BoxDecoration(
                          color: Color(0xff145173),
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                        child: Center(
                          child: Text(
                            'Register',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.4285714286,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Add some spacing between the Register button and the text
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminLoginPage()),
                        );
                      },
                      child: Text(
                        'Have an account? Log In',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.4285714286,
                          color: Color(0xff3669c9),
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
    );
  }
}
