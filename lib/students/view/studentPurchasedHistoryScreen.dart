import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/students/view/studentCreateReport.dart';
import 'package:fluttercalendar_app/students/view/studentTrackingItem.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StudentPurchasedItemsScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Purchased Items',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 75, 13, 114), Color.fromARGB(255, 162, 31, 110)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('purchased_items')
                  .where('buyerId', isEqualTo: _auth.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No purchased items found.',
                      style: GoogleFonts.dmSans(fontSize: 16, color: Colors.white70),
                    ),
                  );
                } else {
                  List<DocumentSnapshot> purchasedItems = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: purchasedItems.length,
                    itemBuilder: (context, index) {
                      final item = purchasedItems[index].data() as Map<String, dynamic>;
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                          vertical: MediaQuery.of(context).size.height * 0.01,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF232526), Color(0xFF414345)],
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (item['imageUrl'] != null) ...[
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(item['imageUrl']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              ],
                              Text(
                                item['itemName'],
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width * 0.045,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Text(
                                'Description: ${item['itemDescription']}',
                                style: GoogleFonts.dmSans(
                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Text(
                                'Price: RM${item['itemPrice'].toStringAsFixed(2)}',
                                style: GoogleFonts.dmSans(
                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Text(
                                'Quantity: ${item['itemQuantity']}',
                                style: GoogleFonts.dmSans(
                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Text(
                                'Category: ${item['itemCategory']}',
                                style: GoogleFonts.dmSans(
                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Text(
                                'Seller ID: ${item['sellerId']}',
                                style: GoogleFonts.dmSans(
                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Text(
                                'Purchase Date: ${DateFormat('yyyy-MM-dd – kk:mm').format((item['purchaseDate'] as Timestamp).toDate())}',
                                style: GoogleFonts.dmSans(
                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StudentTrackingItemScreen(itemId: purchasedItems[index].id),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.local_shipping, color: Colors.white),
                                    label: Text(
                                      'Track Item',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width * 0.04,
                                        vertical: MediaQuery.of(context).size.height * 0.015,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StudentCreateReport(
                                            itemId: purchasedItems[index].id,
                                            itemName: item['itemName'],
                                            itemPrice: item['itemPrice'].toString(),
                                            sellerName: item['sellerId'],
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.report, color: Colors.white),
                                    label: Text(
                                      'Report Item',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: MediaQuery.of(context).size.width * 0.04,
                                        vertical: MediaQuery.of(context).size.height * 0.015,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
