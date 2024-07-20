import 'package:flutter/material.dart';
import 'package:fluttercalendar_app/students/models/tutor_model.dart';
import 'package:fluttercalendar_app/students/services/tutor_service.dart';
import 'package:fluttercalendar_app/students/view/studentTutorListScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class studentCreateTutorScreen extends StatefulWidget {
  @override
  _studentCreateTutorScreenState createState() => _studentCreateTutorScreenState();
}

class _studentCreateTutorScreenState extends State<studentCreateTutorScreen> {
  Tutor _newTutor = Tutor(
    id: '',
    fullName: '',
    subject: '',
    dateAvailability: '',
    hoursAvailability: '',
    chargePerHour: 0.0,
    googleMeetLink: '',
    status: '',
  );

  TutorService _tutorService = TutorService();
  String chargePerHourString = '';
  String? _selectedStatus;
  DateTime? _selectedDate; // Add _selectedDate to store the selected date
  final _formKey = GlobalKey<FormState>();

  final RegExp _noSymbolsRegExp = RegExp(r'^[a-zA-Z0-9 ]+$');

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
          'Create Tutor',
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
                colors: [Color.fromARGB(255, 69, 7, 63), Color.fromARGB(255, 224, 120, 47)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Full Name', Icons.person, (value) {
                      setState(() {
                        _newTutor.fullName = value;
                      });
                    }),
                    _buildTextField('Subject', Icons.book, (value) {
                      setState(() {
                        _newTutor.subject = value;
                      });
                    }),
                    _buildDateField('Date Availability', Icons.date_range, context),
                    _buildTextField('Hours for Tutoring', Icons.access_time, (value) {
                      setState(() {
                        _newTutor.hoursAvailability = value;
                      });
                    }),
                    _buildTextField('Charge per Hour', Icons.attach_money, (value) {
                      setState(() {
                        chargePerHourString = value;
                      });
                    }, keyboardType: TextInputType.number),
                    _buildTextField('Google Meet Link', Icons.link, (value) {
                      setState(() {
                        _newTutor.googleMeetLink = value;
                      });
                    }),
                    _buildDropdownButton(),
                    const SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: _createTutor,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Create Tutor',
                          style: GoogleFonts.dmSans(color: Colors.white),
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

  Widget _buildTextField(String label, IconData icon, Function(String) onChanged, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.dmSans(color: Colors.white),
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
        style: GoogleFonts.dmSans(color: Colors.white),
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your $label';
          }
          if (!_noSymbolsRegExp.hasMatch(value)) {
            return 'No symbols allowed in $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField(String label, IconData icon, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.dmSans(color: Colors.white),
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
          child: Text(
            _selectedDate == null ? 'Select Date' : _selectedDate!.toLocal().toString().split(' ')[0],
            style: GoogleFonts.dmSans(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: _selectedStatus,
        decoration: InputDecoration(
          labelText: 'Status',
          labelStyle: GoogleFonts.dmSans(color: Colors.white),
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
        style: GoogleFonts.dmSans(color: Colors.white),
        onChanged: (value) {
          setState(() {
            _selectedStatus = value;
            _newTutor.status = value!;
          });
        },
        items: ['Pending', 'Available', 'Approved', 'Rejected'].map((status) {
          return DropdownMenuItem<String>(
            value: status,
            child: Text(status, style: GoogleFonts.dmSans()),
          );
        }).toList(),
        validator: (value) => value == null ? 'Please select a status' : null,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _newTutor.dateAvailability = picked.toLocal().toString().split(' ')[0];
      });
  }

  void _createTutor() {
    if (_formKey.currentState!.validate()) {
      double chargePerHour = double.tryParse(chargePerHourString) ?? 0.0;
      _newTutor.chargePerHour = chargePerHour;

      String userId = 'userId'; // Replace with the actual user ID

      _tutorService.createTutor(userId, _newTutor).then((createdTutor) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tutor created successfully'),
        ));
        setState(() {
          _newTutor = Tutor(
            id: '',
            fullName: '',
            subject: '',
            dateAvailability: '',
            hoursAvailability: '',
            chargePerHour: 0.0,
            googleMeetLink: '',
            status: '',
          );
          chargePerHourString = '';
          _selectedStatus = null;
          _selectedDate = null; // Reset _selectedDate
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => studentTutorListScreen()),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create tutor: $error'),
        ));
      });
    } else {
      _showErrorDialog(context, 'Your data is in an invalid format. Please register again.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
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
