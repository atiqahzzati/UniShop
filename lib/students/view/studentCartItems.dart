import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentCartItems extends StatelessWidget {
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final int itemQuantity;
  final String itemCategory;
  final String imageUrl;

  StudentCartItems({
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.itemQuantity,
    required this.itemCategory,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 199, 178, 142),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemName,
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Description: $itemDescription',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Price: \$${itemPrice.toStringAsFixed(2)}',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Quantity: $itemQuantity',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Category: $itemCategory',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
