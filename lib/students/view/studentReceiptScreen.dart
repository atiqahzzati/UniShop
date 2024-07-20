import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StudentReceiptScreen extends StatelessWidget {
  final String purchaseId;

  const StudentReceiptScreen({Key? key, required this.purchaseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
        backgroundColor: const Color.fromARGB(0, 80, 14, 92),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 86, 11, 101)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
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
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('purchased_items').doc(purchaseId).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('No data found for this receipt'));
                } else {
                  final itemData = snapshot.data!.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Receipt Details',
                          style: GoogleFonts.dmSans(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Purchase ID: $purchaseId',
                          style: GoogleFonts.dmSans(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Item Name: ${itemData['itemName']}',
                          style: GoogleFonts.dmSans(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Description: ${itemData['itemDescription']}',
                          style: GoogleFonts.dmSans(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Price: RM${itemData['itemPrice'].toStringAsFixed(2)}',
                          style: GoogleFonts.dmSans(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Quantity: ${itemData['itemQuantity']}',
                          style: GoogleFonts.dmSans(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Category: ${itemData['itemCategory']}',
                          style: GoogleFonts.dmSans(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Seller ID: ${itemData['sellerId']}',
                          style: GoogleFonts.dmSans(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Purchase Date: ${DateFormat('yyyy-MM-dd – kk:mm').format((itemData['purchaseDate'] as Timestamp).toDate())}',
                          style: GoogleFonts.dmSans(fontSize: 16, color: Colors.white70),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Back to Shop',
                            style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
