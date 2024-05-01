import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import '../alumni/alumni_dashboard.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference user =
      FirebaseFirestore.instance.collection('user');

  //To get all alumni list
  Stream<QuerySnapshot> getUserStream() {
    final userStream = user.orderBy('timestamp', descending: true).snapshots();
    return userStream;
  }

  Future<String> fetchUserDp(String userId) async {
    try {
      DocumentSnapshot alumniDoc = await user.doc(userId).get();
      if (alumniDoc.exists) {
        Map<String, dynamic> data = alumniDoc.data() as Map<String, dynamic>;
        return data['dpURL'];
      } else {
        return '';
      }
    } catch (e) {
      print('Error fetching alumni name: $e');
      return '';
    }
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

      // if (getUser(email: email) == false) return false;
      return USER?.displayName == null;
    } else {
      return false;
    }
  }

  Future<bool> getUser({
    required String email,
  }) async {
    print(email);
    final postSnapshot = await user.doc(email).get();
    if (postSnapshot == null)
      return false;
    else
      return true;
  }

//----------------------------------------------------------------------------------------------------------------
// ADMIN SECTION
// get collection of alumni_posts
  final CollectionReference announcement =
      FirebaseFirestore.instance.collection('announcement');
  // get collection of alumni_posts
  final CollectionReference admin =
      FirebaseFirestore.instance.collection('admin');

  // To add alumni post data from form to alumni and alumniPosts
Future<void> addAdminAnnouncement({
  required String type,
  required String adminId,
  required String adminName,
  required String caption,
  required String description,
  String? imageURL,
}) {
  String unique = DateTime.now().toIso8601String();
  announcement.doc('$adminId$unique').set({
    'type': type,
    'adminId': adminId,
    'adminName': adminName,
    'caption': caption,
    'description': description,
    'imageURL': imageURL,
    'likes': [],
    'timestamp': Timestamp.now(),
    'notified': false,
  });

  // Adding announcement to admin user data
  DocumentReference adminRef = admin.doc(adminId);
  return adminRef.collection('announcements').doc('$adminId$unique').set({
    'type': type,
    'adminId': adminId,
    'adminName': adminName,
    'caption': caption,
    'description': description,
    'imageURL': imageURL,
    'timestamp': Timestamp.now(),
    'notified': false,
  });
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
      'notified': false,
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
      'notified': false,
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
      'dpURL': dpURL,
      'likes': [],
      'timestamp': Timestamp.now(),
      'notified': false,
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
      'notified': false,
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
    final studentProfileStream = user
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

  // get collection of alumni_posts
  final CollectionReference event_posts =
      FirebaseFirestore.instance.collection('event_posts');
  // get collection of alumni_posts
  final CollectionReference moderator =
      FirebaseFirestore.instance.collection('moderators');

  //To add student details
  Future<void> addModerator({
    required String? moderatorMail,
    required String moderatorName,
    required String about,
    String? dpURL,
    String? linkedIn,
    String? twitter,
    String? mail,
  }) {
    return moderator.doc('$moderatorMail').set({
      'moderatorMail': moderatorMail,
      'moderatorId': moderatorMail,
      'moderatorName': moderatorName,
      'about': about,
      'dpURL': dpURL,
      'linkedIn': linkedIn,
      'twitter': twitter,
      'mail': mail,
    });
  }

  Future<DocumentSnapshot> getModerator({
    required String moderatorId,
  }) async {
    print(moderatorId);
    final postSnapshot = await moderator.doc(moderatorId).get();
    return postSnapshot;
  }

  // To add alumni post data from form to alumni and alumniPosts
  Future<void> addEventPosts({
    required String communityName,
    required String EventTitle,
    required String moderatorId,
    required String moderatorName,
    required String Date,
    required String Venue,
    required String otherDetails,
    String? imageURL,
    String? dpURL,
  }) {
    String unique = DateTime.now().toIso8601String();
    event_posts.doc('$moderatorId$unique').set({
      'communityName': communityName,
      'eventTitle': EventTitle,
      'moderatorId': moderatorId,
      'moderatorName': moderatorName,
      'date': Date,
      'venue': Venue,
      'otherDetails': otherDetails,
      'imageURL': imageURL,
      'dpURL': dpURL,
      'likes': [],
      'timestamp': Timestamp.now(),
      'notified': false,
    });

    //Adding post to alumni user data
    DocumentReference Moderator = moderator.doc(moderatorId);
    return Moderator.collection('posts').doc('$moderatorId$unique').set({
      'eventTitle': EventTitle,
      'moderatorId': moderatorId,
      'moderatorName': moderatorName,
      'date': Date,
      'venue': Venue,
      'otherDetails': otherDetails,
      'imageURL': imageURL,
      'timestamp': Timestamp.now(),
      'notified': false,
    });
  }

  // To get the data for moderator posts
  Stream<QuerySnapshot> getEventPostsStream() {
    final eventPostsStream =
        event_posts.orderBy('timestamp', descending: true).snapshots();
    return eventPostsStream;
  }

  // Update/Edit post data
  List eventPostInstances({
    required String postId,
    required String moderatorId,
  }) {
    // Update the post in the alumni_posts collection
    DocumentReference eventRef = event_posts.doc(postId);

    // Update the post in the alumni user data
    DocumentReference moderatorPostRef =
        moderator.doc(moderatorId).collection('posts').doc(postId);

    return [eventRef, moderatorPostRef];
  }

  //To delete data inside the profile posts and student_posts
  Future<void> deleteEventPost({
    required String moderatorId,
    required String postId,
  }) async {
    try {
      // Delete the document in student profile
      await moderator.doc(moderatorId).collection('posts').doc(postId).delete();
      // Delete the post in student_posts
      await event_posts.doc(postId).delete();

      print('Post deleted successfully');
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

  // Update/Edit post data
  Future<void> updateEventPost({
    required String postId,
    required String moderatorId,
    required String Date,
    required String Venue,
    required String otherDetails,
    required String EventTitle,
  }) async {
    // Update the post in the alumni_posts collection
    await event_posts.doc(postId).update({
      'eventTitle': EventTitle,
      'date': Date,
      'venue': Venue,
      'otherDetails': otherDetails,
      'timestamp': Timestamp.now(),
      'edited': true,
    });

    // Update the post in the alumni user data
    DocumentReference moderatorRef = moderator.doc(moderatorId);
    await moderatorRef.collection('posts').doc(postId).update({
      'eventTitle': EventTitle,
      'date': Date,
      'venue': Venue,
      'otherDetails': otherDetails,
      'timestamp': Timestamp.now(),
      'edited': true,
    });
  }

  Stream<QuerySnapshot> getModeratorProfilePosts(
      {required String moderatorId}) {
    print(moderatorId);
    final moderatorProfileStream = moderator
        .doc(moderatorId)
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return moderatorProfileStream;
  }

  Future<void> enrollStudent({
    required String studentId,
    required String studentName,
    required String department,
    required String batch,
    required String studentMail,
    required String postId,
  }) {
    return event_posts
        .doc(postId)
        .collection('participants')
        .doc(studentId)
        .set({
      'studentId': studentId,
      'studentName': studentName,
      'department': department,
      'batch': batch,
      'mail': studentMail,
      'isVerified': false,
    });
  }

  // To get the data for participant details
  Stream<QuerySnapshot> getEventParticipantsStream({required String postId}) {
    print(postId);
    final moderatorProfileStream =
        event_posts.doc(postId).collection('participants').snapshots();
    return moderatorProfileStream;
  }

  Future<void> verifyStudent(
      {required String studentId, required String postId}) {
    return event_posts
        .doc(postId)
        .collection('participants')
        .doc(studentId)
        .update({
      'isVerified': true,
    });
  }
}
