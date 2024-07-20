import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/students/view/studentForgotPassword.dart';
import 'package:fluttercalendar_app/students/view/studentHomeScreen.dart';
import 'package:fluttercalendar_app/students/view/studentRegisterScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentLoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
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

  void _signInWithEmailAndPassword(BuildContext context) async {
    try {
      final String email = emailController.text.trim();
      final String password = passwordController.text;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to home screen if sign-in is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StudentHomeScreen()),
      );
    } catch (e) {
      // Handle sign-in errors here
      print('Failed to sign in: $e');
      _showErrorDialog(context, 'Incorrect email or password. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double fem = 1.0; // Assuming fem is a dynamic value for scaling

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
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(bottom: 20 * fem),
                      child: Text(
                        'Welcome back to \nOnline UniShop',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          height: 1.3025,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(bottom: 20 * fem),
                      child: Text(
                        'Please enter your email and password',
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
                            margin: EdgeInsets.only(bottom: 30 * fem),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4285714286,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10 * fem),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xfffafafa),
                                    borderRadius: BorderRadius.circular(10 * fem),
                                  ),
                                  child: TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15 * fem),
                                      hintText: 'Insert your email address',
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
                            margin: EdgeInsets.only(bottom: 70 * fem),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Password',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4285714286,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10 * fem),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xfffafafa),
                                    borderRadius: BorderRadius.circular(10 * fem),
                                  ),
                                  child: TextField(
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 15 * fem),
                                      hintText: 'Insert your password',
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
                            margin: EdgeInsets.only(bottom: 40 * fem),
                            width: double.infinity,
                            height: 50 * fem,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color.fromARGB(255, 77, 190, 255), Color(0xFF135073).withOpacity(0.7)],
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
                              onPressed: () => _signInWithEmailAndPassword(context),
                              child: Center(
                                child: Text(
                                  'Log In',
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Navigate to Student Forgot Password Screen on button press
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => StudentForgotPassword()),
                                    );
                                  },
                                  child: Text(
                                    'Forgot Password',
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 1.3025,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Navigate to Admin Register Screen on button press
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => StudentRegisterScreen()),
                                    );
                                  },
                                  child: Text(
                                    'Register Your Account',
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 1.3025,
                                      color: Color.fromARGB(255, 0, 162, 255),
                                    ),
                                  ),
                                ),
                              ],
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
