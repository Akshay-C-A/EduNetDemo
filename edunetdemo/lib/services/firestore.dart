import 'package:cloud_firestore/cloud_firestore.dart';

//----------------------------------------------------------------------------------------------------------------
// ALUMNI SECTION

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
    String? imageURL,
  }) {
    return alumni_posts.add({
      'type': type,
      'alumniName': alumniName,
      'alumniDesignation': alumniDesignation,
      'caption': caption,
      'description': description,
      'imageURL': imageURL,
      'timestamp': Timestamp.now(),
    });
  }

// To get the data for alumni posts
  Stream<QuerySnapshot> getAlumniPostsStream() {
    final alumniPostsStream =
        alumni_posts.orderBy('timestamp', descending: true).snapshots();
    return alumniPostsStream;
  }
//----------------------------------------------------------------------------------------------------------------------
// STUDENT SECTION

  final CollectionReference student_posts =
      FirebaseFirestore.instance.collection('student_posts');

  Stream<QuerySnapshot> getStudentPostsStream() {
    final alumniPostsStream =
        alumni_posts.orderBy('timestamp', descending: true).snapshots();
    return alumniPostsStream;
  }

  Future<void> addStudentPosts({
    required String type,
    required String alumniName,
    required String alumniDesignation,
    required String caption,
    required String description,
    String? imageURL,
  }) {
    return alumni_posts.add({
      'type': type,
      'alumniName': alumniName,
      'alumniDesignation': alumniDesignation,
      'caption': caption,
      'description': description,
      'imageURL': imageURL,
      'timestamp': Timestamp.now(),
    });
  }

//------------------------------------------------------------------------------------------------------------------
//EVENT SECTION

  final CollectionReference event_posts =
      FirebaseFirestore.instance.collection('student_posts');

  Stream<QuerySnapshot> getEventPostsStream() {
    final alumniPostsStream =
        alumni_posts.orderBy('timestamp', descending: true).snapshots();
    return alumniPostsStream;
  }

  Future<void> addEventPosts({
    required String type,
    required String alumniName,
    required String alumniDesignation,
    required String caption,
    required String description,
    String? imageURL,
  }) {
    return alumni_posts.add({
      'type': type,
      'alumniName': alumniName,
      'alumniDesignation': alumniDesignation,
      'caption': caption,
      'description': description,
      'imageURL': imageURL,
      'timestamp': Timestamp.now(),
    });
  }
}
