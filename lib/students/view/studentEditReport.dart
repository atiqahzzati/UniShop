import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentEditReport extends StatefulWidget {
  final String reportId;

  const StudentEditReport({Key? key, required this.reportId}) : super(key: key);

  @override
  _StudentEditReportState createState() => _StudentEditReportState();
}

class _StudentEditReportState extends State<StudentEditReport> {
  late TextEditingController _itemIdController;
  late TextEditingController _itemPriceController;
  late TextEditingController _sellerNameController;
  late TextEditingController _reasonController; // Added reason controller
  late TextEditingController _additionalDetailsController;

  @override
  void initState() {
    super.initState();
    _itemIdController = TextEditingController();
    _itemPriceController = TextEditingController();
    _sellerNameController = TextEditingController();
    _reasonController = TextEditingController(); // Initialized reason controller
    _additionalDetailsController = TextEditingController();
    _fetchReportDetails();
  }

  @override
  void dispose() {
    _itemIdController.dispose();
    _itemPriceController.dispose();
    _sellerNameController.dispose();
    _reasonController.dispose(); // Disposed reason controller
    _additionalDetailsController.dispose();
    super.dispose();
  }

  void _fetchReportDetails() async {
    try {
      DocumentSnapshot reportSnapshot =
          await FirebaseFirestore.instance.collection('reports').doc(widget.reportId).get();

      // Extract report details from the snapshot
      String itemId = reportSnapshot['itemId'];
      String itemPrice = reportSnapshot['itemPrice'];
      String sellerName = reportSnapshot['sellerName'];
      String reason = reportSnapshot['reason']; // Fetch reason from Firestore
      String additionalDetails = reportSnapshot['additionalDetails'];

      // Set the retrieved values to the text controllers
      _itemIdController.text = itemId;
      _itemPriceController.text = itemPrice;
      _sellerNameController.text = sellerName;
      _reasonController.text = reason; // Set reason controller text
      _additionalDetailsController.text = additionalDetails;
    } catch (error) {
      print('Error fetching report details: $error');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Report',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 75, 13, 114),
        elevation: 0,
      ),
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item Information:',
                    style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  _buildTextField('Item ID', _itemIdController, Icons.label),
                  SizedBox(height: 20),
                  _buildTextField('Item Price', _itemPriceController, Icons.attach_money, keyboardType: TextInputType.number),
                  SizedBox(height: 20),
                  _buildTextField('Seller Name', _sellerNameController, Icons.person),
                  SizedBox(height: 20),
                  Text(
                    'Reason for Report:',
                    style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  _buildTextField('Reason', _reasonController, Icons.warning),
                  SizedBox(height: 20),
                  Text(
                    'Additional Details:',
                    style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _additionalDetailsController,
                    decoration: InputDecoration(
                      hintText: 'Additional Details',
                      hintStyle: GoogleFonts.dmSans(color: Colors.white70),
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
                    maxLines: null,
                    style: GoogleFonts.dmSans(color: Colors.white),
                  ),
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _updateReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        child: Text(
                          'Update',
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _deleteReport(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        child: Text(
                          'Delete',
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
        labelStyle: GoogleFonts.dmSans(
          color: Colors.white,
          fontSize: 16,
        ),
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
      style: GoogleFonts.dmSans(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  void _updateReport() {
    // Implement update report action
    // Get the updated values from the text controllers
    String updatedItemId = _itemIdController.text.trim();
    String updatedItemPrice = _itemPriceController.text.trim();
    String updatedSellerName = _sellerNameController.text.trim();
    String updatedReason = _reasonController.text.trim(); // Fetch updated reason
    String updatedAdditionalDetails = _additionalDetailsController.text.trim();

    // Update the report details in Firestore
    FirebaseFirestore.instance.collection('reports').doc(widget.reportId).update({
      'itemId': updatedItemId,
      'itemPrice': updatedItemPrice,
      'sellerName': updatedSellerName,
      'reason': updatedReason, // Update reason in Firestore
      'additionalDetails': updatedAdditionalDetails,
    }).then((_) {
      // Navigate back to report history page after successful update
      Navigator.pop(context);
    }).catchError((error) {
      print('Error updating report: $error');
      // Handle error
    });
  }

  void _deleteReport(BuildContext context) {
    // Implement delete report action
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this report?'),
        actions: [
          TextButton(
            onPressed: () {
              // Delete the report from Firestore
              FirebaseFirestore.instance.collection('reports').doc(widget.reportId).delete().then((_) {
                // Show SnackBar after successfully deleting the report
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Report deleted successfully.'),
                  ),
                );
                // Navigate back to report history page after successful deletion
                Navigator.pop(context);
              }).catchError((error) {
                print('Error deleting report: $error');
                // Handle error
              });
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
