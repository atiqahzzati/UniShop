import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminManageReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Reports',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 75, 13, 114), Color.fromARGB(255, 162, 31, 110)],
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('reports').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No reports found.',
                      style: GoogleFonts.dmSans(fontSize: 16, color: Colors.white70),
                    ),
                  );
                } else {
                  List<DocumentSnapshot> reports = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index].data() as Map<String, dynamic>;
                      if (_containsSymbols(report['itemName'] ?? '')) {
                        _showErrorDialog(context, "Invalid Format",
                            "The item name contains symbols. You are not required to do any action to this report. Please continue settling other user's reports.");
                      } else {
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.04,
                            vertical: MediaQuery.of(context).size.height * 0.01,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Report Details',
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width * 0.045,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                _buildInfoRow('Item Name:', report['itemName'] ?? 'N/A'),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                _buildInfoRow('Item Price:', 'RM${report['itemPrice'] ?? 'N/A'}'),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                _buildInfoRow('Seller Name:', report['sellerName'] ?? 'N/A'),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                _buildInfoRow('Reason:', report['reason'] ?? 'N/A'),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                _buildInfoRow('Details:', report['additionalDetails'] ?? 'N/A'),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                _buildInfoRow('Reported By:', report['reportedBy'] ?? 'N/A'),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                if (report['imageUrl'] != null) Image.network(report['imageUrl']),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => _banUser(context, report['reportedBy'] ?? 'Unknown'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context).size.width * 0.04,
                                          vertical: MediaQuery.of(context).size.height * 0.015,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        'Ban User',
                                        style: GoogleFonts.dmSans(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _deleteReport(context, reports[index].id),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context).size.width * 0.04,
                                          vertical: MediaQuery.of(context).size.height * 0.015,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        'Delete Report',
                                        style: GoogleFonts.dmSans(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _refund(context, report),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context).size.width * 0.04,
                                          vertical: MediaQuery.of(context).size.height * 0.015,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        'Refund',
                                        style: GoogleFonts.dmSans(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label ',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }

  void _showErrorDialog(BuildContext context, String title, String content) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    });
  }

  bool _containsSymbols(String input) {
    RegExp regex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    return regex.hasMatch(input);
  }

  void _banUser(BuildContext context, String userId) {
    FirebaseFirestore.instance.collection('users').doc(userId).update({'isBanned': true});
    Fluttertoast.showToast(
      msg: "User banned successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void _deleteReport(BuildContext context, String reportId) {
    FirebaseFirestore.instance.collection('reports').doc(reportId).delete();
    Fluttertoast.showToast(
      msg: "Report deleted successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white,
    );
  }

  void _refund(BuildContext context, Map<String, dynamic> report) {
    FirebaseFirestore.instance.collection('purchased_items').doc(report['itemId']).update({'status': 'Refunded'});
    Fluttertoast.showToast(
      msg: "Refund processed successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
}
