import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../alumni/alumni_dashboard.dart';

class FirestoreService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference user =
      FirebaseFirestore.instance.collection('user');

  //To get all alumni list
  Stream<QuerySnapshot> getUserStream() {
    final userStream =
        user.orderBy('timestamp', descending: true).snapshots();
    return userStream;
  }


  // Future<Alumni?> getAlumniByEmail(String email) async {
  //   final alumniSnapshot = await _firestore
  //       .collection('alumni')
  //       .where('alumniMail', isEqualTo: email)
  //       .limit(1)
  //       .get();

  //   if (alumniSnapshot.docs.isNotEmpty) {
  //     final alumniData = alumniSnapshot.docs.first.data();
  //     return Alumni(
  //       alumniId: alumniData['alumniMail'],
  //       alumni_name: alumniData['alumniName'],
  //       alumni_designation: alumniData['alumniDesignation'],
  //       skills: alumniData['skills'].cast<String>(),
  //       about: alumniData['about'],
  //       company: alumniData['company'],
  //       linkedIn: alumniData['linkedIn'],
  //       twitter: alumniData['twitter'],
  //       mail: alumniData['mail'],
  //       dpURL: alumniData['dpURL'],
  //     );
  //   } else {
  //     return null;
  //   }
  // }

  // Future<bool> isFirstTime(String email) async {
  //   DocumentReference isUser = alumni.doc(email);

  //   try {
  //     DocumentSnapshot doc = await isUser.get();
  //     return doc.exists;
  //   } catch (error) {
  //     print('Error getting document: $error');
  //     rethrow;
  //   }
  // }

  Future<bool> isFirstTime(String? email) async {
    if (email != null) {
      final USER = await FirebaseAuth.instance.userChanges().first;
      return USER?.displayName == null;
    } else {
      return false;
    }
  }



//----------------------------------------------------------------------------------------------------------------
// ALUMNI SECTION

  // get collection of alumni_posts
  final CollectionReference alumni_posts =
      FirebaseFirestore.instance.collection('alumni_posts');
  // get collection of alumni_posts
  final CollectionReference alumni =
      FirebaseFirestore.instance.collection('alumni');


//To add alumni details
  Future<void> addAlumni({
    required String? alumniMail,
    required String alumniName,
    required String alumniDesignation,
    required String company,
    required String about,
    required List<String> skills,
    String? dpURL,
    String? linkedIn,
    String? twitter,
    String? mail,
  }) {
    return user.doc('$alumniMail').set({
      'alumniMail': alumniMail,
      'alumniId': alumniMail,
      'alumniName': alumniName,
      'alumniDesignation': alumniDesignation,
      'skills': skills,
      'company': company,
      'about': about,
      'dpURL': dpURL,
      'linkedIn': linkedIn,
      'twitter': twitter,
      'mail': mail,
    });
  }

// To get alumni details
  Future<DocumentSnapshot> getAlumni({
    required String alumniId,
  }) async {
    print(alumniId);
    final postSnapshot = await user.doc(alumniId).get();
    return postSnapshot;
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
    String? dpURL,
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
      'dpURL': dpURL,
      'likes': [],
      'timestamp': Timestamp.now(),
    });

    //Adding post to alumni user data
    DocumentReference AlumniName = user.doc(alumniId);
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
    final alumniProfileStream = user
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
    final alumniRef = user.doc(alumniId);
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
      await user.doc(alumniId).collection('posts').doc(postId).delete();
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
    DocumentReference alumniRef = user.doc(alumniId);
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
        user.doc(alumniId).collection('posts').doc(postId);

    return [alumniRef, alumniPostRef];
  }
//----------------------------------------------------------------------------------------------------------------------
// STUDENT SECTION

  final CollectionReference student_posts =
      FirebaseFirestore.instance.collection('student_posts');
    final CollectionReference student =
      FirebaseFirestore.instance.collection('student');

     Future<void> addStudentPosts({
    
    required String studentId,
    required String studentName,
    required String studentDesignation,
    required String caption,
    required String description,
    String? imageURL,
    String? dpURL,
  }) {
    String unique = DateTime.now().toIso8601String();
    student_posts.doc('$studentId$unique').set({
      
      'studentId': studentId,
      'studentName': studentName,
      'studentDesignation': studentDesignation,
      'caption': caption,
      'description': description,
      'imageURL': imageURL,
      'dpURL' : dpURL,
      'likes': [],
      'timestamp': Timestamp.now(),
    });

    //Adding post to student user data
    DocumentReference StudentId = user.doc(studentId);
    return StudentId.collection('posts').doc('$studentId$unique').set({
      'studentId': studentId,
      'studentName': studentName,
      'studentDesignation': studentDesignation,
      'caption': caption,
      'description': description,
      'imageURL': imageURL,
      'timestamp': Timestamp.now(),
    });
  }
   //To add student details
  Future<void> addStudent({
    required String? studentMail,
    required String studentName,
    required String studentDesignation,
    required String studentDept,
    required String studentYear,
    required String about,
    required List<String> skills,
    String? dpURL,
    String? linkedIn,
    String? twitter,
    String? mail,
  }) {
    return user.doc('$studentMail').set({
      'studentMail': studentMail,
      'studentId': studentMail,
      'studentName': studentName,
      'studentDesignation': studentDesignation,
      'skills': skills,
      'studentDept': studentDept,
      'studentYear': studentYear,
      'about': about,
      'dpURL': dpURL,
      'linkedIn': linkedIn,
      'twitter': twitter,
      'mail': mail,
    });
  }
   // Update/Edit post data
  List StudentPostInstances({
    required String postId,
    required String studentId,
  }) {
    // Update the post in the student_posts collection
    DocumentReference studentRef = student_posts.doc(postId);

    // Update the post in the student user data
    DocumentReference studentPostRef =
        user.doc(studentId).collection('posts').doc(postId);

    return [studentRef, studentPostRef];
  }
  Future<DocumentSnapshot> getStudent({
    required String studentId,
  }) async {
    print(studentId);
    final postSnapshot = await user.doc(studentId).get();
    return postSnapshot;
  }

   Stream<QuerySnapshot> getStudentPostsStream() {
    final studentPostsStream =
        student_posts.orderBy('timestamp', descending: true).snapshots();
    return studentPostsStream;
  }


  Stream<QuerySnapshot> getStudentProfilePosts({required String studentId}) {
    print(studentId);
    final studentProfileStream = student
        .doc(studentId)
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return studentProfileStream;
  }
  //To get a single student post
  Future<DocumentSnapshot> getStudentPost({
    required String studentId,
    required String postId,
  }) async {
    print(studentId);
    final studentRef = user.doc(studentId);
    final postSnapshot = await studentRef.collection('posts').doc(postId).get();
    return postSnapshot;
  }
  //To delete data inside the profile posts and student_posts
  Future<void> deleteStudentPost({
    required String studentId,
    required String postId,
  }) async {
    try {
      // Delete the document in student profile
      await user.doc(studentId).collection('posts').doc(postId).delete();
      // Delete the post in student_posts
      await student_posts.doc(postId).delete();

      print('Post deleted successfully');
    } catch (e) {
      print('Error deleting post: $e');
    }
  }
   // Update/Edit post data
  Future<void> updateStudentPost({
    required String postId,
    required String studentId,
    required String caption,
    required String description,
  }) async {
    // Update the post in the alumni_posts collection
    await student_posts.doc(postId).update({
      'caption': caption,
      'description': description,
      'timestamp': Timestamp.now(),
      'edited': true,
    });

    // Update the post in the alumni user data
    DocumentReference studentRef = user.doc(studentId);
    await studentRef.collection('posts').doc(postId).update({
      'caption': caption,
      'description': description,
      'timestamp': Timestamp.now(),
      'edited': true,
    });
  }

  // Update/Edit post data
  List studentPostInstances({
    required String postId,
    required String studentId,
  }) {
    // Update the post in the student_posts collection
    DocumentReference studentRef = student_posts.doc(postId);

    // Update the post in the student user data
    DocumentReference studentPostRef =
        user.doc(studentId).collection('posts').doc(postId);

    return [studentRef, studentPostRef];
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
