import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminBuyItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double fem = 1.0; // Replace with your desired factor value

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Buy Item Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(28.31 * fem, 17.5 * fem, 160.5 * fem, 17.5 * fem),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0c000000),
                    offset: Offset(0 * fem, 1 * fem),
                    blurRadius: 1.5 * fem,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding:  EdgeInsets.fromLTRB(28.31*fem, 17.5*fem, 160.5*fem, 17.5*fem),
                    width:  22,
                    decoration:  BoxDecoration (
                      color:  Color(0xffffffff),
                      boxShadow:  [
                        BoxShadow(
                          color:  Color(0x0c000000),
                          offset:  Offset(0*fem, 1*fem),
                          blurRadius:  1.5*fem,
                        ),
                      ],
                    ),
                    child:
                  Row(
                    crossAxisAlignment:  CrossAxisAlignment.center,
                    children:  [
                  Container(
                    margin:  EdgeInsets.fromLTRB(0*fem, 0*fem, 125.03*fem, 0*fem),
                    width:  7.16*fem,
                    height:  13.98*fem,
                    child:
                  Image.asset(
                    'assets/admin.png',
                    width:  7.16*fem,
                    height:  13.98*fem,
                  ),
                  ),
                  Text(
                    'Search',
                    textAlign:  TextAlign.center,
                    style:  GoogleFonts.dmSans (
                      fontSize:  16,
                      fontWeight:  FontWeight.w500,
                      height:  1.25,
                      letterSpacing:  0.200000003*fem,
                      color:  Color(0xff000000),
                    ),
                  ),
                    ],
                  ),
                  ),
                    ],
                  ),
                  ),// ... Add the content of the first container here
                ],
              ),
            ),
            // Add other containers and widgets here based on the provided code
            // Remember to adjust the widget hierarchy and properties according to your design
        
        );
  }
}

// Add more classes, functions, or widgets as necessary
