import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/common_pages/notification_card.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:edunetdemo/alumni/alumni_view_post.dart';

class AlumniNotification extends StatefulWidget {
  const AlumniNotification({Key? key});

  @override
  State<AlumniNotification> createState() => _AlumniNotificationState();
}

class _AlumniNotificationState extends State<AlumniNotification> {
  final FirestoreService alumniFirestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: alumniFirestoreService.getAlumniPostsStream(),
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

          List alumniPostList = snapshot.data!.docs;
          return ListView.builder(
            itemCount: alumniPostList.length,
            itemBuilder: (context, index) {
              // Get each individual doc
              DocumentSnapshot document = alumniPostList[index];

              // Get data from each doc
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String userName = data['alumniName'];
              String caption = data['caption'];
              String dpURL = data['dpURL'];
              Timestamp timestamp = data['timestamp'];
              String description =
                  data['description'] ?? ''; // Add description field
              String imageURL = data['imageURL'] ?? ''; // Add imageURL field
              String alumniDesignation =
                  data['alumniDesignation'] ?? ''; // Add alumniDesignation field
              String postId = document.id; // Get the document ID for postId
              List<String> likes = List<String>.from(data['likes'] ?? []); // Get likes list or an empty list if null
              String alumniId = data['alumniId'] ?? ''; // Add alumniId field
              bool isAdmin = data['isAdmin'] ?? false; // Add isAdmin field
              String type = data['type'] ?? ''; // Add type field

              // Display as a list title
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlumniViewPost(
                        alumniName: userName,
                        caption: caption,
                        dpURL: dpURL,
                        timestamp:
                            timestamp.toDate(), // Convert Timestamp to DateTime
                        description: description,
                        imageURL: imageURL,
                        alumniDesignation: alumniDesignation,
                        postId: postId,
                        likes: likes,
                        alumniId: alumniId, // Pass alumniId
                        isAdmin: isAdmin,
                        // Pass isAdmin
                        type: type, // Pass type
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
