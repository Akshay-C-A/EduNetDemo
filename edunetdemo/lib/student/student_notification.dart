import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/common_pages/notification_card.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:edunetdemo/student/student_view_post.dart'; // Import StudentViewPost here

class StudentNotification extends StatefulWidget {
  const StudentNotification({Key? key});

  @override
  State<StudentNotification> createState() => _StudentNotificationState();
}

class _StudentNotificationState extends State<StudentNotification> {
  final FirestoreService studentFirestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: studentFirestoreService.getStudentPostsStream(),
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

              // Get data from each doc
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              String userName = data['studentName'];
              String caption = data['caption'];
              String dpURL = data['dpURL'];
              Timestamp timestamp = data['timestamp'];
              String description = data['description']; // Add description field
              String imageURL = data['imageURL']; // Add imageURL field
              String studentDesignation = data['studentDesignation'] ?? ''; // Add studentDesignation field if available
              String postId = document.id; // Get the document ID for postId
              List<String> likes = List<String>.from(data['likes'] ?? []); // Get likes list or an empty list if null
              String studentId = data['studentId']; // Add studentId field
              bool isAdmin = data['isAdmin'] ?? false; // Add isAdmin field

              // Display as a list title
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentViewPost(
                        studentName: userName,
                        caption: caption,
                        dpURL: dpURL,
                        timestamp: timestamp.toDate(), // Convert Timestamp to DateTime
                        description: description,
                        imageURL: imageURL,
                        studentDesignation: studentDesignation,
                        postId: postId,
                        likes: likes,
                        studentId: studentId, // Pass studentId
                        isAdmin: isAdmin, // Pass isAdmin
                      ),
                    ),
                  );
                },
                child: NotificationCard(
                  userName: userName,
                  caption: caption,
                  dpURL: dpURL,
                  timestamp: timestamp,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
