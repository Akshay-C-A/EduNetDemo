import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/common_pages/event_search.dart';
import 'package:edunetdemo/event/event_postcard.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:edunetdemo/services/notification_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  EventPage({super.key});
  bool isAdmin = false;
  EventPage.forAdmin({super.key, required isAdmin});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final FirestoreService firestoreService = FirestoreService();

  List<String> val1 = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EventSearchPage()));
          }),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getEventPostsStream(),
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

          List eventPostList = snapshot.data!.docs;
          return ListView.builder(
            itemCount: eventPostList.length,
            itemBuilder: (context, index) {
              // Get each individual doc
              DocumentSnapshot document = eventPostList[index];
              // String docID = document.id;
              // Get note from each doc
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              String venue = data['venue'];
              String moderatorId = data['moderatorId'];
              String date = data['date'];
              String moderatorName = data['moderatorName'];
              String otherDetails = data['otherDetails'];
              String eventTitle = data['eventTitle'];
              String imageURL = data['imageURL'];
              String dpURL = data['dpURL'];
              String communityName = data['communityName'];
              bool notified = data['notified'] ?? true;
              Timestamp timestamp = data['timestamp'];
              String payment = data['payment'];
              List<String> enrolled = List<String>.from(data['enrolled'] ?? []);
              print("ENROLE evpage ${data['enrolled']}");

              if (notified == false) {
                NotificationService().showNotification(
                  title: communityName,
                  body: otherDetails,
                );
                List ref = firestoreService.eventPostInstances(
                    postId: document.id, moderatorId: moderatorId);
                DocumentReference eventPost = ref[0];
                DocumentReference moderatorProfile = ref[1];

                eventPost.update({'notified': true});
                moderatorProfile.update({'notified': true});
              }

              // Display as a list title
              return EventPostCard(
                isAdmin: widget.isAdmin,
                communityName: communityName,
                date: date,
                venue: venue,
                moderatorId: moderatorId,
                moderatorName: moderatorName,
                otherDetails: otherDetails,
                dpURL: dpURL,
                postId: document.id,
                imageURL: imageURL,
                eventTitle: eventTitle,
                likes: List<String>.from(data['likes'] ?? []),
                timestamp: timestamp,
                payment: payment,
                enrolled: enrolled,
              );
            },
          );
        },
      ),
    );
  }
}
