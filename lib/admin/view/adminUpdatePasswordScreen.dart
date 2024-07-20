import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/admin/view/adminHomeScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminUpdatePasswordScreen extends StatelessWidget {


  
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
                  margin:  EdgeInsets.fromLTRB(0*fem, 2.16*fem, 0*fem, 4.34*fem),
                  height:  783.3,
                  child:
                Row(
                  crossAxisAlignment:  CrossAxisAlignment.center,
                  children:  [
               
               
               
                  ],
                ),
                ),
                  ],
                ),
                ),
               SizedBox(height: 60),
                Container(
                  margin:  EdgeInsets.fromLTRB(25*fem, 0*fem, 0*fem, 20*fem),
                  constraints:  BoxConstraints (
                    maxWidth:  219*fem,
                  ),
                  child:
                Text(
                  'Update Password',
                  style:  GoogleFonts.dmSans(
                    fontSize:  25,
                    fontWeight:  FontWeight.w700,
                    height:  1.3025,
                    color:  Color(0xff0c1a30),
                  ),
                ),
                ),
                
                Container(
                  margin:  EdgeInsets.fromLTRB(25*fem, 0*fem, 0*fem, 0*fem),
                  child:
                Text(
                  'Complete the following to update your password',
                  style:  GoogleFonts.dmSans (
                    fontSize:  14,
                    fontWeight:  FontWeight.w400,
                    height:  1.7857142857,
                    color:  Color(0xff838589),
                  ),
                ),
                ),
                 SizedBox(height: 20),
                Container(
                  padding:  EdgeInsets.fromLTRB(25*fem, 50*fem, 25*fem, 29*fem),
                  width:  double.infinity,
                  child:
                Column(
                  crossAxisAlignment:  CrossAxisAlignment.center,
                  children:  [
                Container(
                  margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 30*fem),
                  child:
                TextButton(
                  onPressed:  () {},
                  style:  TextButton.styleFrom (
                    padding:  EdgeInsets.zero,
                  ),
                  child:
                Container(
                  width:  double.infinity,
                  height:  89*fem,
                  child:
                Container(
                  width:  double.infinity,
                  height:  double.infinity,
                  child:
                Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children:  [
                Container(
                  margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 19*fem),
                  child:
                Text(
                  'New Password',
                  style: GoogleFonts.dmSans (
                    fontSize:  14,
                    fontWeight:  FontWeight.w400,
                    height:  1.4285714286,
                    color:  Color(0xff0c1a30),
                  ),
                ),
                ),
                Container(
                  width:  double.infinity,
                  height:  50*fem,
                  decoration:  BoxDecoration (
                    color:  Color(0xfffafafa),
                    borderRadius:  BorderRadius.circular(10*fem),
                  ),
                  child:
               Row(
                  crossAxisAlignment:  CrossAxisAlignment.center,
                  children:  [
                Container(
                  margin:  EdgeInsets.fromLTRB(20*fem, 0*fem, 129*fem, 0*fem),
                  child:
                Text(
                  'Insert your new password',
                  style:  GoogleFonts.dmSans (
                    fontSize:  14,
                    fontWeight:  FontWeight.w400,
                    height:  1.2857142857,
                    color:  Color(0xffc4c5c4),
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
                ),
                
                Container(
                  margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 70*fem),
                  width:  double.infinity,
                  child:
                Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children:  [
                    
                Container(
                  margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 19*fem),
                  child:
                Text(
                  'Confirm your new password',
                  style:  GoogleFonts.dmSans(
                    fontSize:  14,
                    fontWeight:  FontWeight.w400,
                    height:  1.4285714286,
                    color:  Color(0xff0c1a30),
                  ),
                  
                ),
                
                ),

                

                Container(
                  padding:  EdgeInsets.fromLTRB(20*fem, 16*fem, 20*fem, 16*fem),
                  width:  double.infinity,
                  decoration:  BoxDecoration (
                    color:  Color(0xfffafafa),
                    borderRadius:  BorderRadius.circular(10*fem),
                  ),
                  child:
                Row(
                  crossAxisAlignment:  CrossAxisAlignment.center,
                  children:  [
                Container(
                  margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 129*fem, 0*fem),
                  child:
                Text(
                  'Confirm your new password',
                  style:  GoogleFonts.dmSans (
                    fontSize:  14,
                    fontWeight:  FontWeight.w400,
                    height:  1.2857142857,
                    color:  Color(0xffc4c5c4),
                  ),
                ),
                ),
                Container(
                  margin:  EdgeInsets.fromLTRB(0, 0, 0, 0),
                  width:  20.01,
                  height:  15.57,
                  child:
                Image.asset(
                  'assets/eye.png',
                  width:  20.01,
                  height:  15.57,
                ),
                ),
                  ],
                ),
                ),
                  ],
                ),
                ),
                 SizedBox(height: 70),
                Container(
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 104 * fem),
              width: double.infinity,
              height: 50 * fem,
              decoration: BoxDecoration(
                color: Color(0xff135073),
                borderRadius: BorderRadius.circular(10 * fem),
              ),
              
              child: TextButton(
                onPressed: () {
                  // Navigate to Admin Home Screen on button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminHomeScreen()),
                  );
                },
                
                child: Center(
                  
                  child: Text(
                    'Save Update',
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
                  ],
                ),
                ),
                  ],
                ),
                ),
    );
    
                  }
                }
