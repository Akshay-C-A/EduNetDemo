import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/common_pages/notification_card.dart';
import 'package:edunetdemo/services/firestore.dart';

import 'package:flutter/material.dart';


class StudentNotification extends StatefulWidget {
  const StudentNotification({super.key});

  @override
  State<StudentNotification> createState() => _StudentNotificationState();
}

class _StudentNotificationState extends State<StudentNotification> {
  final FirestoreService StudentFirestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: StudentFirestoreService.getStudentPostsStream(),
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
              // Get each individual doc
              DocumentSnapshot document = studentPostList[index];
              // String docID = document.id;

              // Get note from each doc
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String userName = data['studentName'];
              String caption = data['caption'];
              String dpURL = data['dpURL'];

              // Display as a list title
              return NotificationCard(
                  userName: userName,
                  caption: caption,
                  dpURL: dpURL);
              // return Card(
              //   elevation: 2,
              //   margin: EdgeInsets.all(8),
              //   child: ListTile(
              //     title: Text(noteText),
              //     onTap: () {},
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}
