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
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final itemPriceText = _itemPriceController.text.trim();
        if (itemPriceText.isEmpty) {
          throw Exception('Please enter the item price.');
        }

        if (!RegExp(r'^[0-9]*(?:\.[0-9]*)?$').hasMatch(itemPriceText)) {
          throw Exception('Invalid item price format. Please enter a valid number.');
        }

        final itemPrice = double.parse(itemPriceText);
        final itemQuantity = int.tryParse(_itemQuantityController.text.trim()) ?? 1;

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

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StudentItems(),
          ),
        );
      }
    } catch (error) {
      print('Error selling item: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
        backgroundColor: const Color.fromARGB(255, 199, 178, 142),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 199, 178, 142), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Register Items',
                      style: GoogleFonts.dmSans(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField('Item Name', _itemNameController, Icons.label),
                    _buildTextField('Item Description', _itemDescriptionController, Icons.description, maxLines: 3),
                    _buildTextField('Item Price', _itemPriceController, Icons.attach_money, keyboardType: TextInputType.number),
                    _buildTextField('Quantity', _itemQuantityController, Icons.confirmation_number, keyboardType: TextInputType.number),
                    _buildDropdownField('Item Category', _selectedCategory, (newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    }),
                    _buildImagePicker(),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _sellItem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 8, 61, 105),
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Sell Item',
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(icon, color: Colors.white),
          filled: true,
          fillColor: Colors.black.withOpacity(0.2),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
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
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, Function(String?)? onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
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
          labelStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(Icons.category, color: Colors.white),
          filled: true,
          fillColor: Colors.black.withOpacity(0.2),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
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
        ),
        dropdownColor: Colors.black.withOpacity(0.8),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _uploadItemImage,
      child: Container(
        height: 150.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.0,
          ),
        ),
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  File(_imageFile!.path),
                  fit: BoxFit.cover,
                ),
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
}
