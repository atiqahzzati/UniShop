import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/students/view/studentChatScreen.dart';
import 'package:fluttercalendar_app/students/view/studentHomeReport.dart';
import 'package:fluttercalendar_app/students/view/studentPaymentShopScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentBuyItems extends StatefulWidget {
  @override
  _StudentBuyItemsState createState() => _StudentBuyItemsState();
}

enum SortCriteria { category, price }

class _StudentBuyItemsState extends State<StudentBuyItems> {
  late SortCriteria _sortCriteria = SortCriteria.category;
  List<String> selectedCategories = [];
  RangeValues _priceRange = RangeValues(0, 5000);
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
          'Shop Items',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.report, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentHomeReport(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_alt, color: Colors.white),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ],
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('items').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<DocumentSnapshot> items = snapshot.data!.docs;
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'No items available at the moment.',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    );
                  }

                  // Apply sorting based on selected criteria
                  if (_sortCriteria == SortCriteria.category) {
                    items.sort((a, b) => (a['itemCategory'] as String).compareTo(b['itemCategory'] as String));
                  } else {
                    items.sort((a, b) => (a['itemPrice'] as double).compareTo(b['itemPrice'] as double));
                  }

                  // Filter items based on selected categories and price range
                  List<DocumentSnapshot> filteredItems = items.where((item) {
                    final itemPrice = item['itemPrice'] as double;
                    final itemCategory = item['itemCategory'] as String;
                    return (selectedCategories.isEmpty || selectedCategories.contains(itemCategory)) &&
                        itemPrice >= _priceRange.start &&
                        itemPrice <= _priceRange.end;
                  }).toList();

                  if (filteredItems.isEmpty) {
                    Future.delayed(Duration.zero, () {
                      _showPopupMessage(context, 'No items exist for this selection. Please sort again.');
                    });
                    return Center(
                      child: Text(
                        'No items exist for this selection. Please sort again.',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final itemName = item['itemName'];
                      final itemDescription = item['itemDescription'];
                      final itemPrice = item['itemPrice'];
                      final itemQuantity = item['itemQuantity'];
                      final itemCategory = item['itemCategory'];
                      final imageUrl = item['imageUrl'];
                      final sellerId = item['sellerId'];

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('users').doc(sellerId).get(),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> sellerSnapshot) {
                          if (sellerSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (sellerSnapshot.hasError) {
                            return Center(child: Text('Error: ${sellerSnapshot.error}'));
                          } else {
                            final sellerData = sellerSnapshot.data!.data() as Map<String, dynamic>?;
                            final sellerEmail = sellerData != null ? sellerData['email'] : 'Unknown';

                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10),
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
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(imageUrl ?? ''),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            itemName,
                                            style: GoogleFonts.dmSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Description: $itemDescription',
                                            style: GoogleFonts.dmSans(
                                              fontSize: 16,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Price: RM${itemPrice.toStringAsFixed(2)}',
                                            style: GoogleFonts.dmSans(
                                              fontSize: 16,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Quantity: $itemQuantity',
                                            style: GoogleFonts.dmSans(
                                              fontSize: 16,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Category: $itemCategory',
                                            style: GoogleFonts.dmSans(
                                              fontSize: 16,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Seller Email: $sellerEmail',
                                            style: GoogleFonts.dmSans(
                                              fontSize: 16,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () {
                                                  if (_isItemDataValid(item)) {
                                                    _showConfirmationDialog(item);
                                                  } else {
                                                    _showPopupMessage(context, 'The items are in invalid format hence you are not allowed to buy this items.');
                                                  }
                                                },
                                                icon: Icon(Icons.shopping_bag, color: Colors.white),
                                                label: Text(
                                                  'Buy Items',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () {
                                                  if (_isItemDataValid(item)) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => StudentChatScreen(sellerId: sellerId),
                                                      ),
                                                    );
                                                  } else {
                                                    _showPopupMessage(context, 'You are not allowed to chat with this seller due to incomplete data on the item.');
                                                  }
                                                },
                                                icon: Icon(Icons.chat, color: Colors.white),
                                                label: Text(
                                                  'Chat with Seller',
                                                  style: TextStyle(color: Colors.white),
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
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

  bool _isItemDataValid(DocumentSnapshot item) {
    final itemName = item['itemName'];
    final itemDescription = item['itemDescription'];
    final itemPrice = item['itemPrice'];
    final itemQuantity = item['itemQuantity'];
    final itemCategory = item['itemCategory'];
    final imageUrl = item['imageUrl'];

    if (itemName == null || itemDescription == null || itemPrice == null || itemQuantity == null || itemCategory == null || imageUrl == null) {
      return false;
    }

    if (itemName.isEmpty || itemDescription.isEmpty || itemPrice <= 0 || itemQuantity <= 0 || itemCategory.isEmpty || imageUrl.isEmpty) {
      return false;
    }

    return true;
  }

  void _showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Filter Options',
            style: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Categories:',
                  style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Divider(),
                CheckboxListTile(
                  title: Text('Electronics', style: GoogleFonts.dmSans(fontSize: 16)),
                  value: selectedCategories.contains('Electronics'),
                  onChanged: (value) {
                    setState(() {
                      if (value != null && value) {
                        selectedCategories.add('Electronics');
                      } else {
                        selectedCategories.remove('Electronics');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Books', style: GoogleFonts.dmSans(fontSize: 16)),
                  value: selectedCategories.contains('Books'),
                  onChanged: (value) {
                    setState(() {
                      if (value != null && value) {
                        selectedCategories.add('Books');
                      } else {
                        selectedCategories.remove('Books');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Clothing', style: GoogleFonts.dmSans(fontSize: 16)),
                  value: selectedCategories.contains('Clothing'),
                  onChanged: (value) {
                    setState(() {
                      if (value != null && value) {
                        selectedCategories.add('Clothing');
                      } else {
                        selectedCategories.remove('Clothing');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Furniture', style: GoogleFonts.dmSans(fontSize: 16)),
                  value: selectedCategories.contains('Furniture'),
                  onChanged: (value) {
                    setState(() {
                      if (value != null && value) {
                        selectedCategories.add('Furniture');
                      } else {
                        selectedCategories.remove('Furniture');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Others', style: GoogleFonts.dmSans(fontSize: 16)),
                  value: selectedCategories.contains('Others'),
                  onChanged: (value) {
                    setState(() {
                      if (value != null && value) {
                        selectedCategories.add('Others');
                      } else {
                        selectedCategories.remove('Others');
                      }
                    });
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Select Price Range:',
                  style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Divider(),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 5000,
                  divisions: 50,
                  labels: RangeLabels(
                    'RM${_priceRange.start.round()}',
                    'RM${_priceRange.end.round()}',
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _priceRange = values;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                // Apply filters and close the dialog
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text(
                'Apply',
                style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(DocumentSnapshot item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Purchase'),
          content: Text('Are you sure you want to buy this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _purchaseItem(item);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _purchaseItem(DocumentSnapshot item) async {
    final user = _auth.currentUser;
    if (user != null) {
      final purchaseId = FirebaseFirestore.instance.collection('purchased_items').doc().id;
      await FirebaseFirestore.instance.collection('purchased_items').doc(purchaseId).set({
        'purchaseId': purchaseId,
        'buyerId': user.uid,
        'itemName': item['itemName'],
        'itemDescription': item['itemDescription'],
        'itemPrice': item['itemPrice'],
        'itemQuantity': item['itemQuantity'],
        'itemCategory': item['itemCategory'],
        'imageUrl': item['imageUrl'],
        'sellerId': item['sellerId'],
        'purchaseDate': Timestamp.now(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentPaymentShopScreen(
            purchaseId: purchaseId,
            itemName: item['itemName'],
            itemPrice: item['itemPrice'],
            itemQuantity: item['itemQuantity'],
          ),
        ),
      );
    }
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
