import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class StudentEditItem extends StatefulWidget {
  final String itemId;

  const StudentEditItem({Key? key, required this.itemId}) : super(key: key);

  @override
  _StudentEditItemState createState() => _StudentEditItemState();
}

class _StudentEditItemState extends State<StudentEditItem> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemDescriptionController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();
  String _selectedCategory = 'Electronics';
  String? _imageUrl; // Updated to hold the image URL
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Fetch the item details using the provided item ID
    fetchItemDetails();
  }

  Future<void> fetchItemDetails() async {
    try {
      final DocumentSnapshot itemSnapshot = await FirebaseFirestore.instance
          .collection('items')
          .doc(widget.itemId)
          .get();

      if (itemSnapshot.exists) {
        setState(() {
          _itemNameController.text = itemSnapshot['itemName'];
          _itemDescriptionController.text = itemSnapshot['itemDescription'];
          _itemPriceController.text = itemSnapshot['itemPrice'].toString();
          _itemQuantityController.text = itemSnapshot['itemQuantity'].toString();
          _selectedCategory = itemSnapshot['itemCategory'];
          _imageUrl = itemSnapshot['imageUrl']; // Fetch the image URL
        });
      }
    } catch (error) {
      print('Error fetching item details: $error');
    }
  }

  Future<void> updateItem() async {
    try {
      // Validate inputs
      if (_itemNameController.text.trim().isEmpty ||
          _itemDescriptionController.text.trim().isEmpty ||
          _itemPriceController.text.trim().isEmpty ||
          !RegExp(r'^[0-9]*(?:\.[0-9]*)?$').hasMatch(_itemPriceController.text.trim()) ||
          _itemQuantityController.text.trim().isEmpty ||
          int.tryParse(_itemQuantityController.text.trim()) == null ||
          int.parse(_itemQuantityController.text.trim()) <= 0) {
        _showDialog(context, "Error", "You are required to fill in all the data before updating the item.");
        return;
      }

      String imageUrl = _imageUrl ?? ''; // Initialize imageUrl with the current or fetched URL

      // Upload the image only if a new image is selected
      if (_imageFile != null) {
        final TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('item_images/${widget.itemId}')
            .putFile(_imageFile!);
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      final updatedData = {
        'itemName': _itemNameController.text.trim(),
        'itemDescription': _itemDescriptionController.text.trim(),
        'itemPrice': double.parse(_itemPriceController.text.trim()),
        'itemQuantity': int.parse(_itemQuantityController.text.trim()),
        'itemCategory': _selectedCategory,
        'imageUrl': imageUrl,
      };

      await FirebaseFirestore.instance
          .collection('items')
          .doc(widget.itemId)
          .update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item updated successfully')),
      );

      Navigator.pop(context);
    } catch (error) {
      print('Error updating item: $error');
    }
  }

  Future<void> deleteItem() async {
    try {
      // Check if all fields are filled
      if (_itemNameController.text.trim().isEmpty ||
          _itemDescriptionController.text.trim().isEmpty ||
          _itemPriceController.text.trim().isEmpty ||
          _itemQuantityController.text.trim().isEmpty) {
        _showDialog(context, "Error", "You are required to fill in all the data before deleting the item.");
        return;
      }

      await FirebaseFirestore.instance
          .collection('items')
          .doc(widget.itemId)
          .delete();

      Navigator.pop(context);
    } catch (error) {
      print('Error deleting item: $error');
    }
  }

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
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
          'Edit Items',
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: _getImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: Text('Pick Image', style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(height: 16.0),
                  _imageFile != null
                      ? Image.file(_imageFile!)
                      : _imageUrl != null
                          ? Image.network(_imageUrl!)
                          : Text(
                              'No image selected',
                              style: TextStyle(color: Colors.white),
                            ),
                  SizedBox(height: 16.0),
                  _buildTextField('Item Name', _itemNameController, Icons.label),
                  SizedBox(height: 16.0),
                  _buildTextField('Item Description', _itemDescriptionController, Icons.description, maxLines: 3),
                  SizedBox(height: 16.0),
                  _buildTextField('Item Price', _itemPriceController, Icons.attach_money, keyboardType: TextInputType.number),
                  SizedBox(height: 16.0),
                  _buildTextField('Item Quantity', _itemQuantityController, Icons.format_list_numbered, keyboardType: TextInputType.number),
                  SizedBox(height: 16.0),
                  _buildDropdownButton(),
                  SizedBox(height: 16.0),
                  Center(
                    child: Wrap(
                      spacing: 10.0, // Space between buttons
                      runSpacing: 10.0, // Space between rows of buttons
                      children: [
                        ElevatedButton(
                          onPressed: updateItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                          child: Text(
                            'Update Item',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: deleteItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                          child: Text(
                            'Delete Item',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(horizontal: 122, vertical: 16),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
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
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
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
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildDropdownButton() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      onChanged: (newValue) {
        setState(() {
          _selectedCategory = newValue!;
        });
      },
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
        labelText: 'Item Category',
        labelStyle: TextStyle(color: Colors.white),
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
      style: TextStyle(color: Colors.white),
    );
  }
}
