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

  // get collection of alumni_posts
  final CollectionReference alumni_posts =
      FirebaseFirestore.instance.collection('alumni_posts');
  // final DocumentReference internship_offers = alumni_post.doc('internship_offers');

  // add a user
  // Future<void> addUser({
  //   required String userId,
  //   required String fullName,
  //   required int yearOfStudy,
  // }) {
  //   return users.doc('users').set({
  //     'userId': userId,
  //     'fullName': fullName,
  //     'yearOfStudy': yearOfStudy,
  //   });
  // }

  // // read user data
  // Stream<DocumentSnapshot> getUserData() {
  //   return users.doc('users').snapshots();
  // }

// To get the data for alumni posts
  Stream<QuerySnapshot> getAlumniPostsStream() {
    final alumniPostsStream =
        alumni_posts.orderBy('timestamp', descending: true).snapshots();
    return alumniPostsStream;
  }

  // update user data
  // Future<void> updateUserData({
  //   required String userId,
  //   required String fullName,
  //   required int yearOfStudy,
  // }) {
  //   return users.doc('users').update({
  //     'userId': userId,
  //     'fullName': fullName,
  //     'yearOfStudy': yearOfStudy,
  //   });
  // }
}
