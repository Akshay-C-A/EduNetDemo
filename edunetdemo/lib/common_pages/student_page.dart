import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:edunetdemo/student/student_post_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => StudentPageState();
}

class StudentPageState extends State<StudentPage> {
  @override
  final FirestoreService StudentFirestoreService = FirestoreService();

  final TextEditingController textController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Student Dashboard'),
            ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Text('SignOut'))
          ],
        ),
      ),
      // body: Text('Student Page'),

      // body: StreamBuilder<QuerySnapshot>(
      //   stream: StudentFirestoreService.getAlumniPostsStream(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return Text('Error: ${snapshot.error}');
      //     }

      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     }

      //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      //       return Center(child: Text('No data available'));
      //     }

      //     List alumniPostList = snapshot.data!.docs;
      //     return ListView.builder(
      //       itemCount: alumniPostList.length,
      //       itemBuilder: (context, index) {
      //         // Get each individual doc
      //         DocumentSnapshot document = alumniPostList[index];
      //         // String docID = document.id;

      //         // Get note from each doc
      //         Map<String, dynamic> data =
      //             document.data() as Map<String, dynamic>;
      //         String type = data['type'];
      //         String alumniName = data['alumniName'];
      //         String alumniDesignation = data['alumniDesignation'];
      //         String caption = data['caption'];
      //         String description = data['description'];
      //         String? imageURL = data['imageURL'];

      //         // Display as a list title
      //         return StudentPostCard(
      //             type: type,
      //             studentName: alumniName,
      //             studentDesignation: alumniDesignation,
      //             caption: caption,
      //             description: description,
      //             imageURL: imageURL ?? '');

      //         // return Card(
      //         //   elevation: 2,
      //         //   margin: EdgeInsets.all(8),
      //         //   child: ListTile(
      //         //     title: Text(noteText),
      //         //     onTap: () {},
      //         //   ),
      //         // );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
