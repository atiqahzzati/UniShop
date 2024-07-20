class UserProfile {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String icNumber;
  final String bankAccount;
  final String address;
  final String university;

  UserProfile({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.icNumber,
    required this.bankAccount,
    required this.address,
    required this.university,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      fullName: map['fullName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      icNumber: map['icNumber'],
      bankAccount: map['bankAccount'],
      address: map['address'],
      university: map['university'],
    );
  }
}
