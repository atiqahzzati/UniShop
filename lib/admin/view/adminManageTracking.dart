import 'package:flutter/material.dart';

class AdminManageTracking extends StatefulWidget {
  @override
  _AdminManageTrackingState createState() => _AdminManageTrackingState();
}

class _AdminManageTrackingState extends State<AdminManageTracking> {
  List<ItemTracking> _itemTrackings = [
    ItemTracking(itemName: 'Item 1', trackingStatus: 'Pending'),
    ItemTracking(itemName: 'Item 2', trackingStatus: 'Shipped'),
    ItemTracking(itemName: 'Item 3', trackingStatus: 'Out for Delivery'),
    ItemTracking(itemName: 'Item 4', trackingStatus: 'Delivered'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Tracking',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 199, 178, 142),
      ),
      body: ListView.builder(
        itemCount: _itemTrackings.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_itemTrackings[index].itemName),
            subtitle: Text('Status: ${_itemTrackings[index].trackingStatus}'),
            trailing: ElevatedButton(
              onPressed: () {
                _showStatusOptions(context, index);
              },
              child: Text('Update'),
            ),
          );
        },
      ),
    );
  }

  void _showStatusOptions(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Tracking Status'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatusOption('Pending', index),
                _buildStatusOption('Shipped', index),
                _buildStatusOption('Out for Delivery', index),
                _buildStatusOption('Delivered', index),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(String status, int index) {
    return ListTile(
      title: Text(status),
      onTap: () {
        setState(() {
          _itemTrackings[index].trackingStatus = status;
          Navigator.pop(context);
        });
      },
    );
  }
}

class ItemTracking {
  String itemName;
  String trackingStatus;

  ItemTracking({required this.itemName, required this.trackingStatus});
}
