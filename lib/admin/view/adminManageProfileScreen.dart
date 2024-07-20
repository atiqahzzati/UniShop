import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/admin/view/adminHomeScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminManageProfileScreen extends StatelessWidget {


  
  @override
  Widget build(BuildContext context) {
    double fem = 1.0; // Assuming fem is a dynamic value for scaling
    
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
               SizedBox(height: 20),
                Container(
                  margin:  EdgeInsets.fromLTRB(25*fem, 0*fem, 0*fem, 20*fem),
                  constraints:  BoxConstraints (
                    maxWidth:  219*fem,
                  ),
                  child:
                Text(
                  'Manage Profile',
                  style:  GoogleFonts.dmSans(
                    fontSize:  25,
                    fontWeight:  FontWeight.w700,
                    height:  1.3025,
                    color:  Color(0xff0c1a30),
                  ),
                ),
                ),

                 SizedBox(height: 20),

                Container(
                alignment: Alignment.center,
                child: Icon(
                  Icons.account_circle_outlined, // Your admin profile icon
                  size: 100 * fem, // Adjust the size as needed
                  color: Colors.black, // Example color, change it according to your design
                ),
              ),
               
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
                  'Name',
                  style: GoogleFonts.dmSans (
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
                  'Iwani',
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
                  margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 30*fem),
                  width:  double.infinity,
                  child:  
                Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children:  [
                Container(
                  margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 19*fem),
                  child:  
                Text(
                  'Email',
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
                  'aia@gmail.com',
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
               
                Container(
                  margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 30*fem),
                  width:  double.infinity,
                  child:
                Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children:  [
                Container(
                  margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 19*fem),
                  child:
                Text(
                  'Phone Number',
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
                  'Insert your phone number',
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

                       Container(
                  margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 30*fem),
                  width:  double.infinity,
                  child:
                Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children:  [
                Container(
                  margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 19*fem),
                  child:
                Text(
                  'Address',
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
                  'No 11/1 Jalan Cempaka, \nTaman Cempaka, \n70450 Seremban, Negeri Sembilan',
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
                  'University',
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
                  'UTM',
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
                 SizedBox(height: 30),
               GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminHomeScreen()), // Replace AdminHomeScreen with the actual screen name
                    );
                  },
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
                        'Edit',
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
      ),
                );
       
                      
                  }
                }