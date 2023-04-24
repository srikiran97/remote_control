import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final int cleaningHours;
  final int noOfPoints;
  final int noOfBadges;
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.cleaningHours,
    required this.noOfPoints,
    required this.noOfBadges,
  });

  factory UserModel.initialUser() {
    return const UserModel(
      id: '',
      name: '',
      email: '',
      cleaningHours: -1,
      noOfPoints: -1,
      noOfBadges: -1,
    );
  }

  factory UserModel.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>?;

    return UserModel(
      id: userDoc.id,
      name: userData!['name'],
      email: userData['email'],
      cleaningHours: userData['cleaningHours'],
      noOfPoints: userData['noOfPoints'],
      noOfBadges: userData['noOfBadges'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        cleaningHours,
        noOfPoints,
        noOfBadges,
      ];
}
