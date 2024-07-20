import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/students/view/studentStatusItems.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class StudentPaymentItems extends StatefulWidget {
  final String itemName;
  final double itemPrice;
  final int itemQuantity;
  final String buyerAddress;
  final int shippingTotal;

  StudentPaymentItems({
    required this.itemName,
    required this.itemPrice,
    required this.itemQuantity,
    required this.buyerAddress,
    required this.shippingTotal,
  });

  @override
  _StudentPaymentItemsState createState() => _StudentPaymentItemsState();
}

class _StudentPaymentItemsState extends State<StudentPaymentItems> {
  String _selectedPaymentMethod = 'Cash';
  String _selectedShippingOption = 'COD';
  String _selectedDestination = 'Semenanjung';
  double _shippingFee = 0.0;
  double _totalPayment = 0.0;
  TextEditingController _shippingAddressController = TextEditingController();
  late File _imageFile;

  final ImagePicker _picker = ImagePicker();
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _calculateTotalPayment();
  }

  void _calculateTotalPayment() {
    setState(() {
      if (_selectedShippingOption == 'COD') {
        _shippingFee = 0.0;
      } else {
        _shippingFee = _selectedDestination == 'Semenanjung' ? 8.0 : 20.0;
      }
      _totalPayment = (widget.itemPrice * widget.itemQuantity) + _shippingFee;
    });
  }

  Future<void> _getImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> _uploadImage() async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('proof_of_payment/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = ref.putFile(_imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } catch (error) {
      print('Error uploading image: $error');
      return '';
    }
  }

  Future<void> _uploadProofOfPayment() async {
    setState(() {
      _uploading = true;
    });

    String imageUrl = await _uploadImage();

    setState(() {
      _uploading = false;
    });

    if (imageUrl.isNotEmpty) {
      try {
        // Add payment details to Firestore
        await FirebaseFirestore.instance.collection('payments').add({
          'itemName': widget.itemName,
          'itemPrice': widget.itemPrice,
          'itemQuantity': widget.itemQuantity,
          'buyerAddress': widget.buyerAddress,
          'shippingFee': _shippingFee,
          'totalPayment': _totalPayment,
          'paymentMethod': _selectedPaymentMethod,
          'proofOfPaymentUrl': imageUrl,
          'timestamp': Timestamp.now(),
        });

        // Show success message
        Fluttertoast.showToast(
          msg: "Payment details uploaded successfully!",
          toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Navigate to studentStatusItems.dart after toast message is shown
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentStatusItems(
                itemName: widget.itemName,
                itemPrice: widget.itemPrice,
                itemQuantity: widget.itemQuantity,
                shippingFee: _shippingFee,
                totalPayment: _totalPayment,
              ),
            ),
          );
        });
      } catch (error) {
        // Show error message if there's an issue with Firestore
        Fluttertoast.showToast(
          msg: "Error uploading payment details. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } else {
      // Show error message if there's an issue with image upload
      Fluttertoast.showToast(
        msg: "Error uploading proof of payment. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Selection',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 199, 178, 142),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Item Name: ${widget.itemName}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Item Price: \RM${widget.itemPrice}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Item Quantity: ${widget.itemQuantity}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Shipping Fee: \RM$_shippingFee',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Total Payment: \RM$_totalPayment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Select Payment Method:',
              style: TextStyle(fontSize: 18),
            ),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              onChanged: (newValue) {
                setState(() {
                  _selectedPaymentMethod = newValue!;
                });
              },
              items: ['Cash', 'Transfer'].map((String paymentMethod) {
                return DropdownMenuItem<String>(
                  value: paymentMethod,
                  child: Text(paymentMethod),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Select Shipping Option:',
              style: TextStyle(fontSize: 18),
            ),
            DropdownButtonFormField<String>(
              value: _selectedShippingOption,
              onChanged: (newValue) {
                setState(() {
                  _selectedShippingOption = newValue!;
                  _calculateTotalPayment();
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
                style: TextStyle(fontSize: 18),
              ),
              DropdownButtonFormField<String>(
                value: _selectedDestination,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDestination = newValue!;
                    _calculateTotalPayment();
                  });
                },
                items: ['Semenanjung', 'Sabah/Sarawak'].map((String destination) {
                  return DropdownMenuItem<String>(
                    value: destination,
                    child: Text(destination),
                  );
                }).toList(),
              ),
            ],
            if (_selectedShippingOption == 'Post') ...[
              SizedBox(height: 20),
              Text(
                'Enter Shipping Address:',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                controller: _shippingAddressController,
                decoration: InputDecoration(
                  hintText: 'Enter your shipping address',
                ),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the upload proof of payment page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProofOfPaymentUploadPage(
                      itemName: widget.itemName,
                      itemPrice: widget.itemPrice,
                      itemQuantity:
                      widget.itemQuantity,
                      shippingFee: _shippingFee,
                      totalPayment: _totalPayment,
                      paymentMethod: _selectedPaymentMethod,
                      buyerAddress: _shippingAddressController.text,
                    ),
                  ),
                );
              },
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProofOfPaymentUploadPage extends StatefulWidget {
  final String itemName;
  final double totalPayment;
  final String paymentMethod;
  final double itemPrice;
  final int itemQuantity;
  final double shippingFee;
  final String buyerAddress;

  ProofOfPaymentUploadPage({
    required this.itemName,
    required this.totalPayment,
    required this.paymentMethod,
    required this.itemPrice,
    required this.itemQuantity,
    required this.shippingFee,
    required this.buyerAddress,
  });

  @override
  _ProofOfPaymentUploadPageState createState() =>
      _ProofOfPaymentUploadPageState();
}

class _ProofOfPaymentUploadPageState extends State<ProofOfPaymentUploadPage> {
  File? _imageFile;
  bool _uploading = false;

  final ImagePicker _picker = ImagePicker();

  late double _shippingFee;

  late double _totalPayment;

  @override
  void initState() {
    super.initState();
    _shippingFee = widget.shippingFee; // Initialize _shippingFee
    _totalPayment = widget.totalPayment; // Initialize _totalPayment
  }

  Future<void> _getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadProofOfPayment() async {
    if (_imageFile != null) {
      setState(() {
        _uploading = true;
      });

      // Upload the image to Firebase Storage
      Reference ref = FirebaseStorage.instance.ref().child(
          'proof_of_payment/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = ref.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _uploading = false;
      });

      try {
        // Add payment details to Firestore
        await FirebaseFirestore.instance.collection('payments').add({
          'itemName': widget.itemName,
          'itemPrice': widget.itemPrice,
          'itemQuantity': widget.itemQuantity,
          'shippingFee': _shippingFee,
          'totalPayment': _totalPayment,
          'paymentMethod': widget.paymentMethod,
          'buyerAddress': widget.buyerAddress,
          'proofOfPaymentUrl': downloadUrl,
          'timestamp': Timestamp.now(),
        });

        // Show success message
        Fluttertoast.showToast(
          msg: "Payment details uploaded successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Navigate back to studentStatusItems.dart after a successful upload
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentStatusItems(
                itemName: widget.itemName,
                itemPrice: widget.itemPrice,
                itemQuantity: widget.itemQuantity,
                shippingFee: _shippingFee,
                totalPayment: _totalPayment,
              ),
            ),
          );
        });
      } catch (error) {
        // Show error message if there's an issue with Firestore
        Fluttertoast.showToast(
          msg: "Error uploading payment details. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } else {
      // Show error message if no image is selected
      Fluttertoast.showToast(
        msg: "Please select an image to upload.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Proof of Payment',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 199, 178, 142),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile == null
                ? ElevatedButton(
                    onPressed: _getImage,
                    child: Text('Select Image'),
                  )
                : Image.file(_imageFile!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploading ? null : _uploadProofOfPayment,
              child: Text('Upload'),
            ),
            SizedBox(height: 10),
            if (_uploading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircularProgressIndicator(),
              ),
            if (_uploading)
              Text(
                'Uploading proof of payment...',
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

