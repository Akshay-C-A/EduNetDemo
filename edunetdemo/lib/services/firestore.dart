import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection of alumni_posts
  final CollectionReference alumni_posts =
      FirebaseFirestore.instance.collection('alumni_posts');
  // final DocumentReference internship_offers = alumni_post.doc('internship_offers');

// To add alumni post data from form to firebase
  Future<void> addAlumniPosts({
  required String type,
  required String alumniName,
  required String alumniDesignation,
  required String caption,
  required String description,
}) {
  return alumni_posts.add({
    'type': type,
    'alumniName': alumniName,
    'alumniDesignation': alumniDesignation,
    'caption': caption,
    'description': description,
    'timestamp': Timestamp.now(),
  });
}

// To get the data for alumni posts
  Stream<QuerySnapshot> getAlumniPostsStream() {
    final alumniPostsStream =
        alumni_posts.orderBy('timestamp', descending: true).snapshots();
    return alumniPostsStream;
  }


// get collection of users
  // final CollectionReference users =
  //     FirebaseFirestore.instance.collection('users');

  // // add a user
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

  // // update user data
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
