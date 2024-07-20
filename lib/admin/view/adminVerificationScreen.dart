import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/admin/view/adminUpdatePasswordScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminVerificationScreen extends StatelessWidget {
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
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: [
             SizedBox(height: 90),
           Positioned(
                    left:  25*fem,
                    top:  200*fem,
                    child:
                  Align(
                    child:
                  SizedBox(
                    height: 60,
                    child:
                    
                  Text(
                    'Verification',
                    style:  GoogleFonts.dmSans (
                      fontSize:  25,
                      fontWeight:  FontWeight.w700,
                      height:  1.3025,
                      color:  Color(0xff0c1a30),
                    ),
                  ),
                  ),
                  ),
                  ),
                  Positioned(
              left: 25 * fem,
              top: 192 * fem,
              child: Align(
                child: SizedBox(
                  width: 325 * fem,
                  height: 25 * fem,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'We have sent the verification code to ',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.7857142857,
                        color: Color(0xff838589),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8), // Adding space between the texts
                  Text(
                    '+60*****0890', // Your additional text here
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 100),
                  Positioned(
                    left:  24*fem,
                    top:  314*fem,
                    child:
                  Container(
                    width:  326*fem,
                    height:  92*fem,
                    decoration:  BoxDecoration (
                      borderRadius:  BorderRadius.circular(10*fem),
                    ),
                    child:
                  Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children:  [
                  Container(
                    margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 1*fem, 17*fem),
                    width:  double.infinity,
                    child:
                  Row(
                    crossAxisAlignment:  CrossAxisAlignment.center,
                    children:  [
                  Container(
                    margin:  EdgeInsets.fromLTRB(0*fem, 1*fem, 114*fem, 0*fem),
                    child:
                  Text(
                    'Verification Code',
                    style:  GoogleFonts.dmSans (
                      fontSize:  14,
                      fontWeight:  FontWeight.w500,
                      height:  1.4285714286,
                      color:  Color(0xff0c1a30),
                    ),
                  ),
                  ),
                  Text(
                    'Re-send Code',
                    textAlign:  TextAlign.right,
                    style:  GoogleFonts.dmSans(
                      fontSize:  14,
                      fontWeight:  FontWeight.w500,
                      height:  1.7857142857,
                      color:  Color(0xff3669c9),
                    ),
                  ),
                    ],
                  ),
                  ),
                  Container(
                    width:  double.infinity,
                    height:  50*fem,
                    child:
                  Row(
                    crossAxisAlignment:  CrossAxisAlignment.center,
                    children:  [
                  Container(
                    margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 10*fem, 0*fem),
                    width:  74*fem,
                    height:  double.infinity,
                    decoration:  BoxDecoration (
                      color:  Color(0xfffafafa),
                      borderRadius:  BorderRadius.circular(10*fem),
                    ),
                    child:
                  Center(
                    child:
                  Center(
                    child:
                  Text(
                    '1',
                    textAlign:  TextAlign.center,
                    style:  GoogleFonts.dmSans(
                      fontSize:  14,
                      fontWeight:  FontWeight.w500,
                      height:  1.2857142857,
                      color:  Color(0xff0c1a30),
                    ),
                  ),
                  ),
                  ),
                  ),
                  Container(
                    margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 9*fem, 0*fem),
                    width:  74*fem,
                    height:  double.infinity,
                    decoration:  BoxDecoration (
                      color:  Color(0xfffafafa),
                      borderRadius:  BorderRadius.circular(10*fem),
                    ),
                    child:
                  Center(
                    child:
                  Center(
                    child:
                  Text(
                    '3',
                    textAlign:  TextAlign.center,
                    style:  GoogleFonts.dmSans (
                      fontSize:  14,
                      fontWeight:  FontWeight.w500,
                      height:  1.2857142857,
                      color:  Color(0xff0c1a30),
                    ),
                  ),
                  ),
                  ),
                  ),
                  Container(
                    margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 11*fem, 0*fem),
                    width:  74*fem,
                    height:  double.infinity,
                    decoration:  BoxDecoration (
                      color:  Color(0xfffafafa),
                      borderRadius:  BorderRadius.circular(10*fem),
                    ),
                    child:
                  Center(
                    child:
                  Center(
                    child:
                  Text(
                    '5',
                    textAlign:  TextAlign.center,
                    style:  GoogleFonts.dmSans (
                      fontSize:  14,
                      fontWeight:  FontWeight.w500,
                      height:  1.2857142857,
                      color:  Color(0xff0c1a30),
                    ),
                  ),
                  ),
                  ),
                  ),
                  Container(
                    width:  74*fem,
                    height:  double.infinity,
                    decoration:  BoxDecoration (
                      color:  Color(0xfffafafa),
                      borderRadius:  BorderRadius.circular(10*fem),
                    ),
                    child:
                  Center(
                    child:
                  Center(
                    child:
                  Text(
                    '4',
                    textAlign:  TextAlign.center,
                    style:  GoogleFonts.dmSans (
                      fontSize:  14,
                      fontWeight:  FontWeight.w500,
                      height:  1.2857142857,
                      color:  Color(0xff0c1a30),
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
                  ),SizedBox(height: 200),
                  Positioned(
                    left:  25*fem,
                    top:  529*fem,
                    child:
                  TextButton(
                    // Reset Password Button
                  onPressed: () {
                  // Navigate to Admin Home Screen on button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminUpdatePasswordScreen()),
                  );
                },
                    style:  TextButton.styleFrom (
                      padding:  EdgeInsets.zero,
                    ),
                    child:
                  Container(
                    width:  325*fem,
                    height:  50*fem,
                    decoration:  BoxDecoration (
                      color:  Color(0xff145173),
                      borderRadius:  BorderRadius.circular(10*fem),
                    ),
                    child:
                  Center(
                    child:
                  Text(
                    'Continue',
                    textAlign:  TextAlign.center,
                    style:  GoogleFonts.dmSans(
                      fontSize:  14,
                      fontWeight:  FontWeight.w500,
                      height:  1.4285714286,
                      color:  Color(0xffffffff),
                    ),
                  ),
                  ),
                  ),
                  ),
                  ),
                    ],
                  ),
                  ),
                      );
                    }
                  }