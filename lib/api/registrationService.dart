import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/model.dart';

class RegistrationService {
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('users');

  Future<void> registerUser(UserModelOne user) async {
    try {
      await _usersCollection.doc(user.uid).set(user.toMap());
      print('User registration successful!');
    } catch (e) {
      print('Error registering user: $e');
    }
  }
}
