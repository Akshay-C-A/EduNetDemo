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

  //ALumni functions and collection
  Future<void> addTitle(String title) {
    return internship_offers.add({
      'title': title,
      'timestamp': Timestamp.now(),
    });
  }
  // get collection of alumni_posts
  final CollectionReference alumni_post =
      FirebaseFirestore.instance.collection('alumni_posts');
  // final DocumentReference internship_offers = alumni_post.doc('internship_offers');

  final CollectionReference internship_offers =
      FirebaseFirestore.instance.collection('internship_offers');
  final CollectionReference placement_offers =
      FirebaseFirestore.instance.collection('placement_offers');
  final CollectionReference technical_events =
      FirebaseFirestore.instance.collection('technical_events');

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
  Stream<QuerySnapshot> getInternshipOffersStream() {
    final internshipOffersStream =
        internship_offers.orderBy('timestamp', descending: true).snapshots();
    return internshipOffersStream;
  }

  Stream<QuerySnapshot> getTechnicalEventsStream() {
    return technical_events.orderBy('timestamp', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getPlacementOffersStream() {
    return placement_offers.orderBy('timestamp', descending: true).snapshots();
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
