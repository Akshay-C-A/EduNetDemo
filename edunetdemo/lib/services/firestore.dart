import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection of users
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  // add a user
  Future<void> addUser({
    required String userId,
    required String fullName,
    required int yearOfStudy,
  }) {
    return users.doc('users').set({
      'userId': userId,
      'fullName': fullName,
      'yearOfStudy': yearOfStudy,
    });
  }

  // read user data
  Stream<DocumentSnapshot> getUserData() {
    return users.doc('users').snapshots();
  }

  // update user data
  Future<void> updateUserData({
    required String userId,
    required String fullName,
    required int yearOfStudy,
  }) {
    return users.doc('users').update({
      'userId': userId,
      'fullName': fullName,
      'yearOfStudy': yearOfStudy,
    });
  }

  // Other methods for donations and cart_items...
}
