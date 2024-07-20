import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentTrackingStatus extends StatelessWidget {
  final String itemName;
  final double itemPrice;
  final int itemQuantity;
  final String trackingStatus;

  StudentTrackingStatus({
    required this.itemName,
    required this.itemPrice,
    required this.itemQuantity,
    required this.trackingStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tracking Status',
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
                  'Item Details:',
                  style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Item Name: $itemName',
                  style: GoogleFonts.dmSans(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Item Price: RM$itemPrice',
                  style: GoogleFonts.dmSans(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Item Quantity: $itemQuantity',
                  style: GoogleFonts.dmSans(fontSize: 16),
                ),
                SizedBox(height: 15),
                Text(
                  'Tracking Status:',
                  style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  trackingStatus,
                  style: GoogleFonts.dmSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(trackingStatus), // Color of status text
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    // Define colors for different statuses
    switch (status) {
      case 'Pending':
        return Colors.orange; // Color for 'Pending' status
      case 'Shipped':
        return Colors.blue; // Color for 'Shipped' status
      case 'Out for Delivery':
        return Colors.green; // Color for 'Out for Delivery' status
      case 'Delivered':
        return Colors.black; // Color for 'Delivered' status
      default:
        return Colors.black; // Default color
    }
  }
}
