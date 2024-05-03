import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/common_pages/notification_card.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:flutter/material.dart';

class AlumniNotification extends StatefulWidget {
  const AlumniNotification({super.key});

  @override
  State<AlumniNotification> createState() => _AlumniNotificationState();
}

class _AlumniNotificationState extends State<AlumniNotification> {
  final FirestoreService AlumniFirestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: AlumniFirestoreService.getAlumniPostsStream(),
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
              // String docID = document.id;

              // Get note from each doc
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String userName = data['alumniName'];
              String caption = data['caption'];
              String dpURL = data['dpURL'];
              Timestamp timestamp = data['timestamp'];


              // Display as a list title
              return NotificationCard(
                  userName: userName,
                  caption: caption,
                  dpURL: dpURL, 
                  timestamp: timestamp);
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
