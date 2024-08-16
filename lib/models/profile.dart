import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Profile with ChangeNotifier {
  final String? uid;
  final String email;
  final String role;
  final String firstName;
  final String lastName;
  final String photoUrl;

  Profile({
    required this.uid,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.photoUrl,
  });

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Profile(
      uid: doc.id,
      email: data['email'] ?? '',
      role: data['roleView'] ?? 'member',
      firstName: data['firstName'] ?? 'Valued',
      lastName: data['lastName'] ?? 'Guest',
      photoUrl: data['photoUrl'] ?? '',
    );
  }
}
