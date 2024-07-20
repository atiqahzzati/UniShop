import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttercalendar_app/admin/model/userModel.dart';

class UserService {
  final User user = FirebaseAuth.instance.currentUser!;

  Future<UserProfile> getUserProfile() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (snapshot.exists) {
      return UserProfile.fromMap(snapshot.data()!);
    } else {
      throw Exception('User profile not found');
    }
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'fullName': userProfile.fullName,
      'email': userProfile.email,
      'phoneNumber': userProfile.phoneNumber,
      'icNumber': userProfile.icNumber,
      'bankAccount': userProfile.bankAccount,
      'address': userProfile.address,
      'university': userProfile.university,
    });
  }
}
