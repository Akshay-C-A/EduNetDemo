import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/event/event_postcard.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              // Display as a list title
              return EventPostCard(
                communityName: 'MuLearn',
                date: date,
                venue: venue,
                moderatorId: moderatorId,
                moderatorName: moderatorName,
                otherDetails: otherDetails,
                dpURL: dpURL,
                postId: document.id,
                imageURL: imageURL,
                eventTitle: eventTitle,
                likes: [],
              );
            },
          );
        },
      ),
    );
  }
}
