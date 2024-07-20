import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AdminCreateTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin: Add Tracking Info',
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
              stream: FirebaseFirestore.instance.collection('purchased_items').snapshots(),
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
                              _buildTrackingForm(context, purchasedItems[index].id),
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

  Widget _buildTrackingForm(BuildContext context, String itemId) {
    final _formKey = GlobalKey<FormState>();
    String _trackingNumber = '';
    String _status = 'Processing';

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Tracking Number',
              labelStyle: GoogleFonts.dmSans(color: Colors.white),
              prefixIcon: Icon(Icons.local_shipping, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
            ),
            style: GoogleFonts.dmSans(color: Colors.white),
            onChanged: (value) {
              _trackingNumber = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a tracking number';
              }
              final RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
              if (!regex.hasMatch(value)) {
                return 'Tracking number can only contain alphabets and numbers';
              }
              return null;
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          DropdownButtonFormField<String>(
            value: _status,
            onChanged: (String? newValue) {
              _status = newValue!;
            },
            items: <String>[
              'Processing',
              'Shipped',
              'Delivered',
              'Cancelled',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Status',
              labelStyle: GoogleFonts.dmSans(color: Colors.white),
              prefixIcon: Icon(Icons.info, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
            ),
            dropdownColor: Colors.blueGrey,
            style: GoogleFonts.dmSans(color: Colors.white),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await FirebaseFirestore.instance.collection('purchased_items').doc(itemId).update({
                  'trackingNumber': _trackingNumber,
                  'status': _status,
                });
                Fluttertoast.showToast(
                  msg: "Tracking information updated successfully!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );
              }
            },
            child: Text(
              'Update Tracking Info',
              style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: Colors.white),
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
        ],
      ),
    );
  }
}
