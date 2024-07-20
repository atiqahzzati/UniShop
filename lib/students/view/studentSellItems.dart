import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/students/view/studentItems.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class StudentSellItems extends StatefulWidget {
  @override
  _StudentSellItemsState createState() => _StudentSellItemsState();
}

class _StudentSellItemsState extends State<StudentSellItems> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late TextEditingController _itemNameController;
  late TextEditingController _itemDescriptionController;
  late TextEditingController _itemPriceController;
  late TextEditingController _itemQuantityController;
  String _selectedCategory = 'Electronics';
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _itemDescriptionController = TextEditingController();
    _itemPriceController = TextEditingController();
    _itemQuantityController = TextEditingController();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemDescriptionController.dispose();
    _itemPriceController.dispose();
    _itemQuantityController.dispose();
    super.dispose();
  }

  Future<void> _uploadItemImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedImage;
    });
  }

  Future<void> _sellItem() async {
    try {
      // Show custom loading indicator
      _showLoadingIndicator();

      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final itemPriceText = _itemPriceController.text.trim();
        if (itemPriceText.isEmpty) {
          Navigator.pop(context); // Hide loading indicator
          _showDialog(context, "Error", "Please enter the item price.");
          return;
        }

        if (!RegExp(r'^[0-9]*(?:\.[0-9]*)?$').hasMatch(itemPriceText)) {
          Navigator.pop(context); // Hide loading indicator
          _showDialog(context, "Error", "Invalid item price format. Please enter a valid number.");
          return;
        }

        final itemPrice = double.parse(itemPriceText);
        final itemQuantityText = _itemQuantityController.text.trim();
        if (itemQuantityText.isEmpty) {
          Navigator.pop(context); // Hide loading indicator
          _showDialog(context, "Error", "Please enter the item quantity.");
          return;
        }

        final itemQuantity = int.tryParse(itemQuantityText);
        if (itemQuantity == null || itemQuantity <= 0) {
          Navigator.pop(context); // Hide loading indicator
          _showDialog(context, "Error", "Item quantity must be a positive number.");
          return;
        }

        if (_imageFile == null) {
          Navigator.pop(context); // Hide loading indicator
          _showDialog(context, "Error", "Please upload an image.");
          return;
        }

        final itemData = {
          'itemName': _itemNameController.text.trim(),
          'itemDescription': _itemDescriptionController.text.trim(),
          'itemPrice': itemPrice,
          'itemCategory': _selectedCategory,
          'itemQuantity': itemQuantity,
          'sellerId': currentUser.uid,
        };

        final itemRef = await _firestore.collection('items').add(itemData);

        // Get the auto-generated item ID
        final itemId = itemRef.id;

        if (_imageFile != null) {
          final imageFile = File(_imageFile!.path);
          final Reference storageRef = _storage.ref().child('item_images').child(itemId + '.jpg');
          await storageRef.putFile(imageFile);
          final imageUrl = await storageRef.getDownloadURL();

          // Update the item document in Firestore with the image URL
          await itemRef.update({'imageUrl': imageUrl});
        }

        Navigator.pop(context); // Hide loading indicator

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StudentItems(),
          ),
        );
      }
    } catch (error) {
      Navigator.pop(context); // Hide loading indicator
      print('Error selling item: $error');
    }
  }

  void _showLoadingIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Registering Item...',
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Register Items',
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
                colors: [Color.fromARGB(255, 75, 13, 114), Color.fromARGB(255, 162, 31, 110)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item Information:',
                    style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  _buildTextField('Item Name', _itemNameController, Icons.label),
                  SizedBox(height: 20),
                  _buildTextField('Item Description', _itemDescriptionController, Icons.description, maxLines: 3),
                  SizedBox(height: 20),
                  _buildTextField('Item Price', _itemPriceController, Icons.attach_money, keyboardType: TextInputType.number),
                  SizedBox(height: 20),
                  _buildTextField('Quantity', _itemQuantityController, Icons.confirmation_number, keyboardType: TextInputType.number),
                  SizedBox(height: 20),
                  _buildDropdownField('Item Category', _selectedCategory, (newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  }),
                  SizedBox(height: 20),
                  _buildImagePicker(),
                  SizedBox(height: 20),
                  _buildGradientButton('Sell Item', _sellItem),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.dmSans(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white),
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
    );
  }

  Widget _buildDropdownField(String label, String value, Function(String?)? onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: <String>[
        'Electronics',
        'Books',
        'Clothing',
        'Furniture',
        'Other'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.dmSans(color: Colors.white),
        prefixIcon: Icon(Icons.category, color: Colors.white),
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
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _uploadItemImage,
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
        child: _imageFile != null
            ? Image.file(
                File(_imageFile!.path),
                fit: BoxFit.cover,
              )
            : Icon(
                Icons.add_photo_alternate,
                size: 50.0,
                color: Colors.white,
              ),
        alignment: Alignment.center,
      ),
    );
  }

  Widget _buildGradientButton(String text, Function() onPressed) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 0, 162, 255), Color.fromARGB(255, 0, 166, 255)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
