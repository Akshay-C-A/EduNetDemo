import 'package:cloud_firestore/cloud_firestore.dart';



class FirestoreService {


//----------------------------------------------------------------------------------------------------------------
// ALUMNI SECTION

  // get collection of alumni_posts
  final CollectionReference alumni_posts =
      FirebaseFirestore.instance.collection('alumni_posts');
  // get collection of alumni_posts
  final CollectionReference alumni =
      FirebaseFirestore.instance.collection('alumni');
  // final DocumentReference internship_offers = alumni_post.doc('internship_offers');

//To add user details
Future<void> addAlumni({
    required String? alumniMail,
    required String alumniName,
    required String alumniDesignation,
    required String company,
    required String about,
    required String skills,
    String? dpURL,
    String? linkedIn,
    String? twitter,
    String? mail,
  }) {
    return alumni.doc('$alumniMail').set({
      'alumniMail' : alumniMail,
      'alumniId': alumniMail,
      'alumniName': alumniName,
      'alumniDesignation': alumniDesignation,
      'skills' : skills,
      'company' : company,
      'about' : about,
      'dpURL': dpURL,
      'linkedIn' : linkedIn,
      'twitter' : twitter,
      'mail' : alumniMail,
    });
  }

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
    String unique = DateTime.now().toIso8601String();
    alumni_posts.doc('$alumniId$unique').set({
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
    return AlumniName.collection('posts').doc('$alumniId$unique').set({
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

//To get a single alumni post
  Future<DocumentSnapshot> getAlumniPost({
    required String alumniId,
    required String postId,
  }) async {
    print(alumniId);
    final alumniRef = alumni.doc(alumniId);
    final postSnapshot = await alumniRef.collection('posts').doc(postId).get();
    return postSnapshot;
  }

  //To delete data inside the profile posts and alumni_posts
  Future<void> deletePost({
    required String alumniId,
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

  // Update/Edit post data
  Future<void> updateAlumniPost({
    required String postId,
    required String type,
    required String alumniId,
    required String caption,
    required String description,
  }) async {
    // Update the post in the alumni_posts collection
    await alumni_posts.doc(postId).update({
      'type': type,
      'caption': caption,
      'description': description,
      'timestamp': Timestamp.now(),
      'edited': true,
    });

    // Update the post in the alumni user data
    DocumentReference alumniRef = alumni.doc(alumniId);
    await alumniRef.collection('posts').doc(postId).update({
      'type': type,
      'caption': caption,
      'description': description,
      'timestamp': Timestamp.now(),
      'edited': true,
    });
  }

  // Update/Edit post data
  List alumniPostInstances({
    required String postId,
    required String alumniId,
  }) {
    // Update the post in the alumni_posts collection
    DocumentReference alumniRef = alumni_posts.doc(postId);

    // Update the post in the alumni user data
    DocumentReference alumniPostRef =
        alumni.doc(alumniId).collection('posts').doc(postId);

    return [alumniRef, alumniPostRef];
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
