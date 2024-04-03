import 'package:cloud_firestore/cloud_firestore.dart';

//----------------------------------------------------------------------------------------------------------------
// ALUMNI SECTION

class FirestoreService {
  static int num = 0;
  // get collection of alumni_posts
  final CollectionReference alumni_posts =
      FirebaseFirestore.instance.collection('alumni_posts');
  // get collection of alumni_posts
  final CollectionReference alumni =
      FirebaseFirestore.instance.collection('alumni');
  // final DocumentReference internship_offers = alumni_post.doc('internship_offers');

// To add alumni post data from form to alumni and alumniPosts
  Future<void> addAlumniPosts({
    required String type,
    required String alumniId,
    required String alumniName,
    required String alumniDesignation,
    required String caption,
    required String description,
    String? imageURL,
  }) {
    num++;
    alumni_posts.doc('$alumniId$num').set({
      'type': type,
      'alumniId': alumniId,
      'alumniName': alumniName,
      'alumniDesignation': alumniDesignation,
      'caption': caption,
      'description': description,
      'imageURL': imageURL,
      'timestamp': Timestamp.now(),
    });

    //Adding post to alumni user data
    DocumentReference AlumniName = alumni.doc(alumniId);
    return AlumniName.collection('posts').doc('$alumniId$num').set({
      'type': type,
      'alumniId': alumniId,
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

//To get the data for posts in alumni profile
  Stream<QuerySnapshot> getAlumniProfilePosts({required String alumniId}) {
    print(alumniId);
    final alumniProfileStream = alumni
        .doc(alumniId)
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return alumniProfileStream;
  }

  //To delete data inside the profile posts and alumni_posts
  Future<void> deletePost(
      {required String alumniId,
      required String postId,
      }) async {
    try {
      // Delete the document in alumni profile
      await alumni.doc(alumniId).collection('posts').doc(postId).delete();
      // Delete the post in alumni_posts
      await alumni_posts.doc(postId).delete();

      print('Post deleted successfully');
    } catch (e) {
      print('Error deleting post: $e');
    }
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
    required String studentName,
    required String studentDesignation,
    required String caption,
    required String description,
    String? imageURL,
  }) {
    return alumni_posts.add({
      'type': type,
      'alumniName': studentName,
      'alumniDesignation': studentDesignation,
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
