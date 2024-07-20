import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/admin/view/adminVerificationScreen.dart';

class AdminForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double fem = 1.0; // Assuming fem is a dynamic value for scaling

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // Status Bar
              padding: EdgeInsets.fromLTRB(33.39 * fem, 14 * fem, 14.5 * fem, 12 * fem),
              width: double.infinity,
              height: 44 * fem,
              decoration: BoxDecoration(
                color: Color(0xffffffff),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 
                ],
              ),
            ),
            SizedBox(height: 60),
           
            Container(
              // Reset Password Text
              margin: EdgeInsets.fromLTRB(25 * fem, 0 * fem, 0 * fem, 20 * fem),
              child: Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 25 * fem,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff0c1a30),
                ),
              ),
            ),
            Container(
              // Enter Email Text
              margin: EdgeInsets.fromLTRB(25 * fem, 0 * fem, 0 * fem, 0 * fem),
              child: Text(
                'Enter your email address to reset your password',
                style: TextStyle(
                  fontSize: 14 * fem,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff838589),
                ),
              ),
            ),
            Container(
              // Email Input Field
              padding: EdgeInsets.fromLTRB(25 * fem, 100 * fem, 25 * fem, 296 * fem),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // Email Label
                    margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 19 * fem),
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14 * fem,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff0c1a30),
                      ),
                    ),
                  ),
                  Container(
                    // Email Input Field
                    padding: EdgeInsets.fromLTRB(20 * fem, 16 * fem, 20 * fem, 16 * fem),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xfffafafa),
                      borderRadius: BorderRadius.circular(10 * fem),
                    ),
                    child: Text(
                      'aia@gmail.com', // Replace this with a TextField for email input
                      style: TextStyle(
                        fontSize: 14 * fem,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff0c1a30),
                      ),
                    ),
                  ),
                  SizedBox(height: 30), // Adjust this value for spacing
                  TextButton(
                    // Reset Password Button
                     onPressed: () {
                  // Navigate to Admin Home Screen on button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminVerificationScreen()),
                  );
                },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Container(
                      width: double.infinity,
                      height: 50 * fem,
                      decoration: BoxDecoration(
                        color: Color(0xff145173),
                        borderRadius: BorderRadius.circular(10 * fem),
                      ),
                      child: Center(
                        child: Text(
                          'Reset Your Password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14 * fem,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffffffff),
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
    );
  }
}
