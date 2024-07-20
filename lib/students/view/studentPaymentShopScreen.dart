import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class StudentPaymentShopScreen extends StatefulWidget {
  final String purchaseId;
  final String itemName;
  final double itemPrice;
  final int itemQuantity;

  const StudentPaymentShopScreen({
    Key? key,
    required this.purchaseId,
    required this.itemName,
    required this.itemPrice,
    required this.itemQuantity,
  }) : super(key: key);

  @override
  _StudentPaymentShopScreenState createState() => _StudentPaymentShopScreenState();
}

class _StudentPaymentShopScreenState extends State<StudentPaymentShopScreen> {
  XFile? _paymentImageFile;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  bool _isPaymentSubmitted = false;

  String _selectedShippingOption = 'COD';
  String _selectedDestination = 'Semenanjung';
  double _shippingFee = 0.0;
  TextEditingController _shippingAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _calculateShippingFee();
  }

  void _calculateShippingFee() {
    setState(() {
      if (_selectedShippingOption == 'COD') {
        _shippingFee = 0.0;
      } else {
        _shippingFee = _selectedDestination == 'Semenanjung' ? 8.0 : 20.0;
      }
    });
  }

  Future<void> _uploadPaymentImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _paymentImageFile = pickedImage;
    });
  }

  Future<void> _savePaymentImage(String purchaseId) async {
    if (_paymentImageFile == null) {
      _showPopupMessage(context, "Payment failed. You are required to upload your screenshot of the bank receipt. Please try again.");
      return;
    }

    if (_selectedShippingOption == 'Post' && _shippingAddressController.text.isEmpty) {
      _showPopupMessage(context, "You are required to fill in the shipping option and shipping address. Please submit again.");
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final imageFile = File(_paymentImageFile!.path);
    final Reference storageRef = _storage.ref().child('payment_images').child(purchaseId + '.jpg');
    await storageRef.putFile(imageFile);
    final imageUrl = await storageRef.getDownloadURL();

    // Update the purchase document in Firestore with the payment image URL
    await _firestore.collection('purchased_items').doc(purchaseId).update({
      'paymentImageUrl': imageUrl,
      'status': 'completed',
      'completedAt': Timestamp.now(),
      'shippingOption': _selectedShippingOption,
      'shippingDestination': _selectedDestination,
      'shippingAddress': _shippingAddressController.text,
      'shippingFee': _shippingFee,
    });

    setState(() {
      _isUploading = false;
      _isPaymentSubmitted = true;
    });

    // Show success message
    Fluttertoast.showToast(
      msg: "Payment details uploaded successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    // Navigate back to shop after a successful upload
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalPayment = (widget.itemPrice * widget.itemQuantity) + _shippingFee;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Items',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
              future: FirebaseFirestore.instance.collection('purchased_items').doc(widget.purchaseId).get(),
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Details',
                            style: GoogleFonts.dmSans(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Purchase ID: ${widget.purchaseId}',
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
                          if (itemData['imageUrl'] != null) ...[
                            Text(
                              'Item Image:',
                              style: GoogleFonts.dmSans(fontSize: 16, color: Colors.white70),
                            ),
                            SizedBox(height: 8),
                            Image.network(
                              itemData['imageUrl'],
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 16),
                          ],
                          Text(
                            'Select Shipping Option:',
                            style: GoogleFonts.dmSans(fontSize: 18, color: Colors.white),
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedShippingOption,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedShippingOption = newValue!;
                                _calculateShippingFee();
                              });
                            },
                            items: ['COD', 'Post'].map((String shippingOption) {
                              return DropdownMenuItem<String>(
                                value: shippingOption,
                                child: Text(shippingOption),
                              );
                            }).toList(),
                          ),
                          if (_selectedShippingOption == 'Post') ...[
                            SizedBox(height: 20),
                            Text(
                              'Select Destination:',
                              style: GoogleFonts.dmSans(fontSize: 18, color: Colors.white),
                            ),
                            DropdownButtonFormField<String>(
                              value: _selectedDestination,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedDestination = newValue!;
                                  _calculateShippingFee();
                                });
                              },
                              items: ['Semenanjung', 'Sabah/Sarawak'].map((String destination) {
                                return DropdownMenuItem<String>(
                                  value: destination,
                                  child: Text(destination),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Enter Shipping Address:',
                              style: GoogleFonts.dmSans(fontSize: 18, color: Colors.white),
                            ),
                            TextFormField(
                              controller: _shippingAddressController,
                              decoration: InputDecoration(
                                hintText: 'Enter your shipping address',
                                hintStyle: GoogleFonts.dmSans(color: Colors.white70),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white70),
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
                            ),
                          ],
                          SizedBox(height: 16),
                          Text(
                            'Shipping Fee: RM$_shippingFee',
                            style: GoogleFonts.dmSans(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            'Total Payment: RM${totalPayment.toStringAsFixed(2)}',
                            style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: _uploadPaymentImage,
                            child: Container(
                              height: 150.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 146, 140, 140),
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: Colors.grey[400]!,
                                  width: 1.0,
                                ),
                              ),
                              child: _paymentImageFile != null
                                  ? Image.file(
                                      File(_paymentImageFile!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.add_photo_alternate,
                                      size: 50.0,
                                      color: Colors.white,
                                    ),
                              alignment: Alignment.center,
                            ),
                          ),
                          SizedBox(height: 16),
                          if (_isUploading)
                            Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 8),
                                  Text(
                                    'Uploading...',
                                    style: GoogleFonts.dmSans(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          if (!_isUploading && _isPaymentSubmitted)
                            Text(
                              'Payment Submitted Successfully!',
                              style: GoogleFonts.dmSans(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              await _savePaymentImage(widget.purchaseId);
                            },
                            child: Text(
                              'Submit Payment',
                              style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 86, 255, 92),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
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

  void _showPopupMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
