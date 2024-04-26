// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:studentprofile/services/firestore.dart';
// import 'package:studentprofile/student_post_card.dart';

// class StudentPage extends StatefulWidget {
//   const StudentPage({super.key});
//   @override
//   State<StudentPage> createState() => _StudentPageState();
// }

// class _StudentPageState extends State<StudentPage> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     setState(() {});
//   }

//   final FirestoreService firestoreService = FirestoreService();

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         stream: firestoreService.getStudentPostsStream(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No data available'));
//           }

//           List studentPostList = snapshot.data!.docs;
//           return ListView.builder(
//             itemCount: studentPostList.length,
//             itemBuilder: (context, index) {
//               // Get each individual doc
//               DocumentSnapshot document = studentPostList[index];
//               // String docID = document.id;

//               // Get note from each doc
//               Map<String, dynamic> data =
//                   document.data() as Map<String, dynamic>;
//               String studentId = data['studentId'];
//               String studentName = data['studentName'];
//               String studentDesignation = data['studentDesignation'];
//               String caption = data['caption'];
//               String description = data['description'];
//               String? imgURL = data['imageURL'];
//               String? dpURL = data['dpURL'];

//               // Display as a list title
//               return StudentPostCard(
//                 studentId: studentId,
//                 studentName: studentName,
//                 studentDesignation: studentDesignation,
//                 caption: caption,
//                 description: description,
//                 imageURL: imgURL ?? '',
//                 dpURL: dpURL ?? '',
//                 postId: document.id,
//                 likes: List<String>.from(data['likes'] ?? []),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:edunetdemo/student/student_post_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class StudentPage extends StatefulWidget {
  const StudentPage({super.key});
  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  final FirestoreService firestoreService = FirestoreService();

  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getStudentPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          List studentPostList = snapshot.data!.docs;
          return ListView.builder(
            itemCount: studentPostList.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = studentPostList[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String studentId = data['studentId'];
              String studentName = data['studentName'];
              String studentDesignation = data['studentDesignation'];
             
              String caption = data['caption'];
              String description = data['description'];
              String? imgURL = data['imageURL'];
              String? dpURL = data['dpURL'];

              return StudentPostCard(
                studentId: studentId,
                studentName: studentName,
                studentDesignation: studentDesignation,
                
                caption: caption,
                description: description,
                imageURL: imgURL ?? '',
                dpURL: dpURL ?? '',
                postId: document.id,
                likes: List<String>.from(data['likes'] ?? []),
              );
            },
          );
        },
      ),
    );
  }
}