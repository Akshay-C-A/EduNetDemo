import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/event/event_participation.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:flutter/material.dart';

class PostedEvents extends StatefulWidget {
  const PostedEvents({super.key});

  @override
  State<PostedEvents> createState() => _PostedEventsState();
}

class _PostedEventsState extends State<PostedEvents> {
  FirestoreService firestoreService = FirestoreService();

  final List<Map<String, dynamic>> postedEvents = [
    {
      'title': 'Flutter Meetup',
      'date': 'April 28, 2024',
      'venue': 'Google Campus, Mountain View',
      'imageUrl': 'https://example.com/flutter_meetup.jpg',
      // 'details': 'Join us for an exciting Flutter Meetup event! We\'ll have talks, workshops, and networking opportunities for Flutter developers of all levels.',
    },
    {
      'title': 'Blockchain Conference',
      'date': 'May 15, 2024',
      'venue': 'San Francisco Convention Center',
      'imageUrl': 'https://example.com/blockchain_conference.jpg',
      // 'details': 'Explore the future of blockchain technology and its applications in various industries. Featuring keynote speakers, panel discussions, and workshops.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posted Events'),
      ),
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
            return Center(child: Text('No Events Posted'));
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

              String eventTitle = data['eventTitle'];
              String date = data['date'];
              String venue = data['venue'];
              String imageURL = data['imageURL'];

              // Display as a list title
              return EventNotificationCard(
                title: eventTitle,
                date: date,
                venue: venue,
                imageUrl: imageURL,
                // details: postedEvents[index]['details'],
              );
            },
          );
        },
      ),
    );
  }
}

class EventNotificationCard extends StatelessWidget {
  final String title;
  final String date;
  final String venue;
  final String imageUrl;

  const EventNotificationCard({
    super.key,
    required this.title,
    required this.date,
    required this.venue,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the PostedEvent screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventParticipation()),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date: $date',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'Venue: $venue',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
