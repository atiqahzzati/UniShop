import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/admin/view/adminLoginPage.dart';
import 'package:fluttercalendar_app/students/view/studentLoginScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class UserRoleScreen extends StatelessWidget {
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
                    SizedBox(height: 60),
                    Image.asset(
                      'assets/unishop_logo.png', // Ensure this path is correct
                      height: 150 * fem, // Enlarged logo
                    ),
                    SizedBox(height: 40),
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
                    SizedBox(height: 50),
                    Container(
                      margin: EdgeInsets.only(bottom: 20 * fem),
                      child: Text(
                        'Select Your Role',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          height: 1.3025,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 50 * fem),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 30 * fem),
                            width: double.infinity,
                            height: 50 * fem,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color.fromARGB(255, 99, 198, 255), Color(0xFF135073).withOpacity(0.7)],
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
                              onPressed: () {
                                // Navigate to Admin Login Screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AdminLoginPage()),
                                );
                              },
                              child: Center(
                                child: Text(
                                  'Admin',
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
                            width: double.infinity,
                            height: 50 * fem,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color.fromARGB(255, 99, 198, 255), Color(0xFF135073).withOpacity(0.7)],
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
                              onPressed: () {
                                // Navigate to Student Login Screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => StudentLoginPage()),
                                );
                              },
                              child: Center(
                                child: Text(
                                  'Student',
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
