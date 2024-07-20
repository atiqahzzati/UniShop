import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminManageReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report History',
          style: GoogleFonts.dmSans(
            fontSize: screenSize.width * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 199, 178, 142), // Using primary color from adminHomeScreen.dart
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('reports').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final reports = snapshot.data!.docs;
              return ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  final data = report.data() as Map<String, dynamic>;
                  final itemId = data['itemId'] ?? '';
                  final reason = data['reason'] ?? '';
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportDetailsPage(itemId: itemId),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      color: Colors.white, // Using white color for card background
                      margin: EdgeInsets.only(bottom: screenSize.width * 0.04),
                      child: ListTile(
                        title: Text(
                          'Item ID: $itemId',
                          style: GoogleFonts.dmSans(
                            fontSize: screenSize.width * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87, // Adjusting text color
                          ),
                        ),
                        subtitle: Text(
                          'Reason: $reason',
                          style: GoogleFonts.dmSans(
                            fontSize: screenSize.width * 0.035,
                            color: Colors.grey[700], // Adjusting text color
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color.fromARGB(255, 199, 178, 142), // Using primary color for icon
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class ReportDetailsPage extends StatefulWidget {
  final String itemId;

  const ReportDetailsPage({Key? key, required this.itemId}) : super(key: key);

  @override
  _ReportDetailsPageState createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  String? _selectedAction;
  String? _selectedUser;
  String _bankInfo = '';
  String _selectedStatus = 'Pending'; // Initialize with 'Pending'
  List<QueryDocumentSnapshot> _users = [];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report Details',
          style: GoogleFonts.dmSans(
            fontSize: screenSize.width * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 199, 178, 142), // Using primary color from adminHomeScreen.dart
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Item ID: ${widget.itemId}',
                style: GoogleFonts.dmSans(
                  fontSize: screenSize.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                'Select action:',
                style: GoogleFonts.dmSans(
                  fontSize: screenSize.width * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              DropdownButton<String?>(
                value: _selectedAction,
                onChanged: (value) {
                  setState(() {
                    _selectedAction = value;
                    if (value == 'Banned Seller') {
                      _fetchUsers();
                    }
                  });
                },
                items: <String?>['Refund', 'Banned Seller', null]
                    .map<DropdownMenuItem<String?>>(
                      (String? value) => DropdownMenuItem<String?>(
                        value: value,
                        child: Text(
                          value ?? 'Select an action',
                          style: GoogleFonts.dmSans(
                            fontSize: screenSize.width * 0.04,
                            color: Colors.black87, // Adjusting text color
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              if (_selectedAction == 'Banned Seller') ...[
                SizedBox(height: screenSize.height * 0.02),
                Text(
                  'Select user to ban:',
                  style: GoogleFonts.dmSans(
                    fontSize: screenSize.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                DropdownButton<String?>(
                  value: _selectedUser,
                  onChanged: (value) {
                    setState(() {
                      _selectedUser = value;
                    });
                  },
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(
                        'Select a user',
                        style: GoogleFonts.dmSans(
                          fontSize: screenSize.width * 0.04,
                          color: Colors.black87, // Adjusting text color
                        ),
                      ),
                    ),
                    ..._users.map((user) {
                      final data = user.data() as Map<String, dynamic>;
                      return DropdownMenuItem<String?>(
                        value: user.id,
                        child: Text(
                          data['email'] ?? 'Unknown', // Changed to display email
                          style: GoogleFonts.dmSans(
                            fontSize: screenSize.width * 0.04,
                            color: Colors.black87, // Adjusting text color
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
              SizedBox(height: screenSize.height * 0.02),
              Text(
                'Select status:', // Add status selection
                style: GoogleFonts.dmSans(
                  fontSize: screenSize.width * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              DropdownButton<String>(
                value: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
                items: <String>['Pending', 'Approved', 'Rejected', 'Completed']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.dmSans(
                            fontSize: screenSize.width * 0.04,
                            color: Colors.black87, // Adjusting text color
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: screenSize.height * 0.02),
              if (_selectedAction == 'Refund') ...[
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _bankInfo = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter buyer\'s bank info',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              SizedBox(height: screenSize.height * 0.02),
              ElevatedButton(
                onPressed: _performAction,
                child: Text('Confirm'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 199, 178, 142), // Using primary color for button background
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _fetchUsers() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        _users = snapshot.docs;
      });
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  void _performAction() {
    if (_selectedAction == 'Refund') {
      _showMessage('The item will be refunded directly to the user\'s account. Please wait for the process to be settled after 30 days.');
    } else if (_selectedAction == 'Banned Seller' && _selectedUser != null && _selectedUser!.isNotEmpty) {
      _banSeller();
    } else {
      _showMessage('Please select an action.');
    }
  }

  void _banSeller() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && currentUser.email == 'admin@utm.my') {
      try {
        await FirebaseFirestore.instance.collection('users').doc(_selectedUser).delete();
        _showMessage('The seller with ID $_selectedUser has been banned and deleted from Firestore.');
      } catch (error) {
        _showMessage('Error deleting user: $error');
      }
    } else {
      _showMessage('You do not have permission to perform this action.');
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Message'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
