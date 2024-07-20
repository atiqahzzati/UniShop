import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/admin/view/adminHomeScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminLoginPage extends StatelessWidget {
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

      // Check if the email is admin@utm.my
      if (email == 'admin@utm.my') {
        // Navigate to home screen if sign-in is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen()),
        );
      } else {
        // Sign out the user
        await _auth.signOut();

        // Show error message if the email is not authorized
        _showErrorDialog(context, 'You are not authorized for this role. Please try logging in as a student.');
      }
    } catch (e) {
      // Handle sign-in errors here
      print('Failed to sign in: $e');
      _showErrorDialog(context, 'Failed to sign in. Please check your email and password and try again.');
    }
  }

  void _resetPassword(BuildContext context) {
    final TextEditingController resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reset Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Please enter your email to receive a password reset link."),
              TextField(
                controller: resetEmailController,
                decoration: InputDecoration(hintText: "Email"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await _auth.sendPasswordResetEmail(email: resetEmailController.text.trim());
                  Navigator.of(context).pop();
                  _showErrorDialog(context, 'Password reset email sent.');
                } catch (e) {
                  Navigator.of(context).pop();
                  _showErrorDialog(context, 'Failed to send password reset email. Please try again.');
                }
              },
              child: Text("Send"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
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
                            margin: EdgeInsets.only(bottom: 30 * fem),
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
                                    _resetPassword(context);
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
                                // TextButton(
                                //   onPressed: () {
                                //     // Add the logic for register if needed
                                //   },
                                //   child: Text(
                                //     'Register',
                                //     textAlign: TextAlign.right,
                                //     style: GoogleFonts.dmSans(
                                //       fontSize: 14,
                                //       fontWeight: FontWeight.w500,
                                //       height: 1.3025,
                                //       color: Colors.white,
                                //     ),
                                //   ),
                                // ),
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
