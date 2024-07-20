// models/user.dart
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

// models/tutor_application.dart

class TutorApplication {
  final String id;
  final User applicant;
  final String description;
  final bool approved;

  TutorApplication({required this.id, required this.applicant, required this.description, required this.approved});
}

// models/tutor_request.dart
class TutorRequest {
  final String id;
  final User student;
  final String subject;

  TutorRequest({required this.id, required this.student, required this.subject});
}
