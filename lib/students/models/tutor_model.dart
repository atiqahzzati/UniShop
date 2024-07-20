class Tutor {
  String id;
  String fullName;
  String subject;
  String? dateAvailability;
  String? hoursAvailability;
  double chargePerHour;
  String googleMeetLink;
  String status; // Add status field

  Tutor({
    required this.id,
    required this.fullName,
    required this.subject,
    this.dateAvailability,
    this.hoursAvailability,
    required this.chargePerHour,
    required this.googleMeetLink,
    required this.status, // Initialize status field
  });

  factory Tutor.fromMap(Map<String, dynamic> map) {
    return Tutor(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      subject: map['subject'] ?? '',
      dateAvailability: map['dateAvailability'],
      hoursAvailability: map['hoursAvailability'],
      chargePerHour: map['chargePerHour'] ?? 0.0,
      googleMeetLink: map['googleMeetLink'] ?? '',
      status: map['status'] ?? '', // Initialize status field
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'subject': subject,
      'dateAvailability': dateAvailability ?? '',
      'hoursAvailability': hoursAvailability ?? '',
      'chargePerHour': chargePerHour,
      'googleMeetLink': googleMeetLink,
      'status': status, // Include status field in the map
    };
  }
}
