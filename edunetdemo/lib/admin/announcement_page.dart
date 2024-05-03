import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/admin/admin_postcard.dart';
import 'package:edunetdemo/alumni/alumni_post_card.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:edunetdemo/services/notification_services.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  AdminPage({super.key});
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirestoreService firestoreService = FirestoreService();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("Announcement"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getAnnouncementPostsStream(),
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

          List adminpostList = snapshot.data!.docs;
          return ListView.builder(
            itemCount: adminpostList.length,
            itemBuilder: (context, index) {
              // Get each individual doc
              DocumentSnapshot document = adminpostList[index];
              // String docID = document.id;

              // Get note from each doc
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String type = data['type'];
              String adminId = data['adminId'];
              String adminName = data['adminName'];
              String caption = data['caption'];
              String description = data['description'];
              String? imgURL = data['imageURL'];
              bool notified = data['notified'] ?? true;
              Timestamp timestamp = data['timestamp'];


              if (notified == false) {
                NotificationService().showNotification(
                  title: adminName,
                  body: description,
                );
                List ref = firestoreService.adminPostInstances(
                    postId: document.id, adminId: adminId);
                DocumentReference adminPost = ref[0];
                DocumentReference adminProfile = ref[1];

                adminPost.update({'notified': true});
                adminProfile.update({'notified': true});
              }

              // Display as a list title
              return AdminPostCard(
                type: type,
                adminId: adminId,
                adminName: adminName,
                caption: caption,
                description: description,
                imageURL: imgURL ?? '',
                postId: document.id,
                timestamp: timestamp,
              );
            },
          );
        },
      ),
    );
  }
}
