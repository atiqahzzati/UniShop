import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/students/view/studentEditItems.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentProductItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // If no user is logged in, return an empty Scaffold
      return Scaffold();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'List of Products',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF232526), Color(0xFF414345)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('items')
                  .where('sellerId', isEqualTo: currentUser.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final items = snapshot.data!.docs;
                  if (items.isEmpty) {
                    // If no items are found for the user, display a message
                    return Center(
                      child: Text(
                        'You haven\'t created any items yet.',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final itemId = item.id; // Retrieve the item ID
                      final itemName = item['itemName'];
                      final itemDescription = item['itemDescription'];
                      final itemPrice = item['itemPrice'];
                      final itemQuantity = item['itemQuantity'];
                      final itemCategory = item['itemCategory'];
                      final imageUrl = item['imageUrl']; // Fetch the image URL

                      return GestureDetector(
                        onTap: () {
                          // Navigate to the StudentEditItems page with the selected item's ID
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentEditItem(itemId: itemId),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color.fromARGB(255, 75, 13, 114), Color.fromARGB(255, 162, 31, 110)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(10),
                              title: Text(
                                itemName,
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Item ID: $itemId', // Display the item ID
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'Description: $itemDescription',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'Price: \RM${itemPrice.toStringAsFixed(2)}',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'Quantity: $itemQuantity',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'Category: $itemCategory',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              leading: Container(
                                width: 100,
                                height: 100,
                                child: imageUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey[400],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
