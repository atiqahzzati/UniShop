import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackingHistoryScreen extends StatelessWidget {
  void _showEditDialog(BuildContext context, DocumentSnapshot item) {
    final TextEditingController _itemIdController = TextEditingController(text: item['itemId']);
    final TextEditingController _itemNameController = TextEditingController(text: item['itemName']);
    final TextEditingController _trackingNoController = TextEditingController(text: item['trackingNo']);
    String _selectedStatus = item['status'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Tracking Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _itemIdController,
                decoration: InputDecoration(labelText: 'Item ID'),
              ),
              TextFormField(
                controller: _itemNameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              TextFormField(
                controller: _trackingNoController,
                decoration: InputDecoration(labelText: 'Tracking No'),
              ),
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
                  _selectedStatus = newValue!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('trackingItems').doc(item.id).update({
                  'itemId': _itemIdController.text,
                  'itemName': _itemNameController.text,
                  'trackingNo': _trackingNoController.text,
                  'status': _selectedStatus,
                }).then((_) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tracking item updated successfully')));
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update tracking item: $error')));
                });
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                _deleteTrackingItem(context, item);
              },
              child: Text('Delete'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Change the color of the delete button
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteTrackingItem(BuildContext context, DocumentSnapshot item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Tracking Item'),
          content: Text('Are you sure you want to delete this tracking item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('trackingItems').doc(item.id).delete().then((_) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Close the edit dialog as well
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tracking item deleted successfully')));
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete tracking item: $error')));
                });
              },
              child: Text('Delete'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Change the color of the delete button
              ),
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
        title: Text(
          'Tracking History',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 199, 178, 142),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('trackingItems').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No tracking items available'));
          } else {
            final trackingItems = snapshot.data!.docs;

            return ListView.builder(
              itemCount: trackingItems.length,
              itemBuilder: (context, index) {
                final item = trackingItems[index];
                final itemId = item['itemId'];
                final itemName = item['itemName'];
                final trackingNo = item['trackingNo'];
                final status = item['status'];
                final timestamp = item['timestamp'] as Timestamp?;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(itemName),
                    subtitle: Text('Tracking No: $trackingNo\nStatus: $status'),
                    trailing: Text(timestamp != null ? timestamp.toDate().toString() : 'No date'),
                    onTap: () => _showEditDialog(context, item),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
