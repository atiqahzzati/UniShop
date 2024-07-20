import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/students/view/trackingHistoryScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTrackingItemScreen extends StatefulWidget {
  @override
  _AddTrackingItemScreenState createState() => _AddTrackingItemScreenState();
}

class _AddTrackingItemScreenState extends State<AddTrackingItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemIdController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _trackingNoController = TextEditingController();
  String _selectedStatus = 'Pending';

  void _saveTrackingItem() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('trackingItems').add({
        'itemId': _itemIdController.text,
        'itemName': _itemNameController.text,
        'trackingNo': _trackingNoController.text,
        'status': _selectedStatus,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tracking item added successfully')));
        _formKey.currentState!.reset();
        setState(() {
          _selectedStatus = 'Pending';
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add tracking item: $error')));
      });
    }
  }

  void _navigateToTrackingHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TrackingHistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Tracking Item',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 199, 178, 142),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _navigateToTrackingHistory,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _itemIdController,
                decoration: InputDecoration(labelText: 'Item ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _itemNameController,
                decoration: InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _trackingNoController,
                decoration: InputDecoration(labelText: 'Tracking No'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the tracking number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(labelText: 'Status'),
                items: [
                  'Pending',
                  'Order Placed',
                  'In Transit',
                  'Out for Delivery',
                  'Delivered',
                  'Completed',
                  'Failed'
                ].map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a status';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveTrackingItem,
                child: Text('Add Tracking Item'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
