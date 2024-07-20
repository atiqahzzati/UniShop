import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/admin/view/adminManageTracking.dart';
import 'package:fluttercalendar_app/students/view/buyerTrackingHistoryScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentStatusItems extends StatelessWidget {
  final String itemName;
  final double itemPrice;
  final int itemQuantity;
  final double shippingFee;
  final double totalPayment;

  StudentStatusItems({
    required this.itemName,
    required this.itemPrice,
    required this.itemQuantity,
    required this.shippingFee,
    required this.totalPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Item Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 199, 178, 142),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Item Name: $itemName',
                  style: GoogleFonts.dmSans(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Item Price: \RM$itemPrice',
                  style: GoogleFonts.dmSans(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Item Quantity: $itemQuantity',
                  style: GoogleFonts.dmSans(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Shipping Fee: \RM$shippingFee',
                  style: GoogleFonts.dmSans(fontSize: 16),
                ),
                SizedBox(height: 15),
                Text(
                  'Total Payment: \RM$totalPayment',
                  style: GoogleFonts.dmSans(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12), // Adjust spacing for buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                         Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminManageTracking(),
                          ),
                        ); 
                        // Add functionality for payment status button
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blue, // Change text color here
                      ),
                      child: Text(
                        'Payment Status',
                        style: GoogleFonts.dmSans(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //  Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => StudentTrackingStatus(itemName: '', itemPrice: itemPrice, itemQuantity: itemQuantity, trackingStatus: '',),
                        //   ),
                        // ); 
                        // Add functionality for tracking status button

                         Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BuyerTrackingHistoryScreen(),
                          ),
                        ); 

                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 225, 131, 59), // Change text color here
                      ),
                      child: Text(
                        'Tracking Status',
                        style: GoogleFonts.dmSans(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
