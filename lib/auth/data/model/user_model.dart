import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String userId;
  final String email;

  final String emergencyName;
  final String emergencyNumber;
  final int age;

  UserModel({
    required this.name,
    required this.userId,
    required this.email,

    required this.emergencyName,
    required this.emergencyNumber,
    required this.age,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'userId': userId,
    'email': email,

    'emergencyName': emergencyName,
    'emergencyNumber': emergencyNumber,
    'age': age,
  };

  factory UserModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return UserModel(
      name: doc.data()?['name'] ?? '',
      userId: doc.id,
      email: doc.data()?['email'] ?? '',

      emergencyName: doc.data()?['emergencyName'] ?? '',
      emergencyNumber: doc.data()?['emergencyNumber'] ?? '',
      age: doc.data()?['age'] ?? 0,
    );
  }

  UserModel copyWith({
    String? name,
    String? userId,
    String? email,
    String? phone,
    String? emergencyName,
    String? emergencyNumber,
    int? age,
  }) {
    return UserModel(
      name: name ?? this.name,
      userId: userId ?? this.userId,
      email: email ?? this.email,

      emergencyName: emergencyName ?? this.emergencyName,
      emergencyNumber: emergencyNumber ?? this.emergencyNumber,
      age: age ?? this.age,
    );
  }

  @override
  String toString() {
    return 'UserModel{name: $name, userId: $userId, email: $email,  emergencyName: $emergencyName, emergencyNumber: $emergencyNumber, age: $age}';
  }
}