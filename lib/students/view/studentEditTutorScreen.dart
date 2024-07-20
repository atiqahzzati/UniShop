import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/students/models/tutor_model.dart';
import 'package:fluttercalendar_app/students/services/tutor_service.dart';
import 'package:google_fonts/google_fonts.dart';

class studentEditTutorScreen extends StatefulWidget {
  final Tutor tutor;

  const studentEditTutorScreen({Key? key, required this.tutor}) : super(key: key);

  @override
  _studentEditTutorScreenState createState() => _studentEditTutorScreenState();
}

class _studentEditTutorScreenState extends State<studentEditTutorScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _subjectController;
  late TextEditingController _dateAvailabilityController;
  late TextEditingController _hoursAvailabilityController;
  late TextEditingController _chargePerHourController;
  late TextEditingController _googleMeetLinkController;

  final TutorService _tutorService = TutorService();
  String? _selectedStatus;

  final List<String> statusTypes = ['Pending', 'Available', 'Approved', 'Rejected'];

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.tutor.fullName);
    _subjectController = TextEditingController(text: widget.tutor.subject);
    _dateAvailabilityController = TextEditingController(text: widget.tutor.dateAvailability ?? '');
    _hoursAvailabilityController = TextEditingController(text: widget.tutor.hoursAvailability ?? '');
    _chargePerHourController = TextEditingController(text: widget.tutor.chargePerHour.toString());
    _googleMeetLinkController = TextEditingController(text: widget.tutor.googleMeetLink);

    _selectedStatus = statusTypes.contains(widget.tutor.status) ? widget.tutor.status : statusTypes.first;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _subjectController.dispose();
    _dateAvailabilityController.dispose();
    _hoursAvailabilityController.dispose();
    _chargePerHourController.dispose();
    _googleMeetLinkController.dispose();
    super.dispose();
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
          'Edit Tutor',
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
                  _buildTextField(_fullNameController, 'Full Name', Icons.person),
                  _buildTextField(_subjectController, 'Subject', Icons.book),
                  _buildTextField(_dateAvailabilityController, 'Date Availability', Icons.date_range),
                  _buildTextField(_hoursAvailabilityController, 'Hours Availability', Icons.access_time),
                  _buildTextField(_chargePerHourController, 'Charge per Hour', Icons.attach_money, keyboardType: TextInputType.number),
                  _buildTextField(_googleMeetLinkController, 'Google Meet Link', Icons.link),
                  _buildDropdownButton(),
                  const SizedBox(height: 16.0),
                  Center(
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: [
                        ElevatedButton(
                          onPressed: _editTutor,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Save',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _deleteTutor,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Delete',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
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
        style: TextStyle(color: Colors.white),
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildDropdownButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: _selectedStatus,
        decoration: InputDecoration(
          labelText: 'Status',
          labelStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(Icons.info, color: Colors.white),
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
        onChanged: (value) {
          setState(() {
            _selectedStatus = value;
          });
        },
        items: statusTypes.map((status) {
          return DropdownMenuItem<String>(
            value: status,
            child: Text(status),
          );
        }).toList(),
      ),
    );
  }

  void _editTutor() {
    if (_fullNameController.text.isEmpty ||
        _subjectController.text.isEmpty ||
        _dateAvailabilityController.text.isEmpty ||
        _hoursAvailabilityController.text.isEmpty ||
        _chargePerHourController.text.isEmpty ||
        _googleMeetLinkController.text.isEmpty ||
        _selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields before saving.')),
      );
      return;
    }

    String fullName = _fullNameController.text;
    String subject = _subjectController.text;
    String dateAvailability = _dateAvailabilityController.text;
    String hoursAvailability = _hoursAvailabilityController.text;
    double chargePerHour = double.tryParse(_chargePerHourController.text) ?? 0.0;
    String googleMeetLink = _googleMeetLinkController.text;
    String status = _selectedStatus ?? '';

    Map<String, dynamic> updatedData = {
      'fullName': fullName,
      'subject': subject,
      'dateAvailability': dateAvailability,
      'hoursAvailability': hoursAvailability,
      'chargePerHour': chargePerHour,
      'googleMeetLink': googleMeetLink,
      'status': status,
    };

    _tutorService.updateTutor(widget.tutor.id, updatedData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tutor updated successfully')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update tutor: $error')),
      );
    });
  }

  void _deleteTutor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Tutor'),
          content: const Text('Are you sure you want to delete this tutor?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _tutorService.deleteTutor(widget.tutor.id).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tutor deleted successfully')),
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete tutor: $error')),
                  );
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
