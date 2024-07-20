import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttercalendar_app/students/models/tutor_model.dart';

class TutorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 Future<Tutor> createTutor(String userId, Tutor tutor) async {
    try {
      // Check if required fields are not empty
      if (tutor.fullName.isEmpty ||
          tutor.subject.isEmpty ||
          tutor.dateAvailability!.isEmpty ||
          tutor.hoursAvailability!.isEmpty ||
          tutor.googleMeetLink.isEmpty) {
        throw Exception('All fields are required');
      }

      // Create a new document in the 'tutoringDetails' collection
      DocumentReference docRef = await _firestore.collection('tutoringDetails').add({
        'userId': userId, // Associate tutor with user
        'fullName': tutor.fullName,
        'subject': tutor.subject,
        'dateAvailability': tutor.dateAvailability,
        'hoursAvailability': tutor.hoursAvailability,
        'chargePerHour': tutor.chargePerHour,
        'googleMeetLink': tutor.googleMeetLink,
      });

      // Retrieve the document ID and update the tutor object
      tutor.id = docRef.id;

      return tutor;
    } catch (e) {
      throw Exception('Failed to create tutor: $e');
    }
  }

  Future<List<Tutor>> getAllTutors() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('tutoringDetails').get();
      List<Tutor> tutors = querySnapshot.docs.map((doc) => Tutor.fromMap(doc.data() as Map<String, dynamic>)).toList();
      return tutors;
    } catch (error) {
      throw Exception('Failed to get all tutors: $error');
    }
  }

  Future<List<Tutor>> getTutorsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('tutoringDetails').where('userId', isEqualTo: userId).get();
      List<Tutor> tutors = querySnapshot.docs.map((doc) => Tutor.fromMap(doc.data() as Map<String, dynamic>)).toList();
      return tutors;
    } catch (error) {
      throw Exception('Failed to get tutors by user ID: $error');
    }
  }

  Future<void> updateTutor(String tutorId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('tutoringDetails').doc(tutorId).update(updatedData);
    } catch (error) {
      throw Exception('Failed to update tutor: $error');
    }
  }

   Future<void> updateTutorStatus(String tutorId, String newStatus) async {
    try {
      await _firestore.collection('tutoringDetails').doc(tutorId).update({'status': newStatus});
    } catch (error) {
      throw Exception('Failed to update tutor status: $error');
    }
  }
  

  Future<void> deleteTutor(String tutorId) async {
    try {
      await _firestore.collection('tutoringDetails').doc(tutorId).delete();
    } catch (error) {
      throw Exception('Failed to delete tutor: $error');
    }
  }
}
