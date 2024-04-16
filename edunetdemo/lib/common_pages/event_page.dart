import 'package:flutter/material.dart';
import 'package:edunetdemo/event/eventpostcard.dart';
 // Updated import

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => PostCardListState();
}

class PostCardListState extends State<EventPage> {
  List<EventPostCard> events = [
    EventPostCard(
      location: 'Location 1',
      time: '10:00 AM',
      date: '2024-03-26',
      photo: 'assets/image1.jpg',
      details: 'Event details 1',
      title: 'Event Title 1',
    ),
    EventPostCard(
      location: 'Location 2',
      time: '11:00 AM',
      date: '2024-03-27',
      photo: 'assets/image2.jpg',
      details: 'Event details 2',
      title: 'Event Title 2',
    ),
    EventPostCard(
      location: 'Location 3',
      time: '12:00 PM',
      date: '2024-03-28',
      photo: 'assets/image3.jpg',
      details: 'Event details 3',
      title: 'Event Title 3',
    ),
    EventPostCard(
      location: 'Location 4',
      time: '01:00 PM',
      date: '2024-03-29',
      photo: 'assets/image4.jpg',
      details: 'Event details 4',
      title: 'Event Title 4',
    ),
    EventPostCard(
      location: 'Location 5',
      time: '02:00 PM',
      date: '2024-03-30',
      photo: 'assets/image5.jpg',
      details: 'Event details 5',
      title: 'Event Title 5',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      backgroundColor: Colors.grey[200],
      // appBar: AppBar(
      //   title: Text('Awesome Quotes'),
      //   centerTitle: true,
      //   backgroundColor: Colors.redAccent,
      // ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: EventPostCard(
              location: events[index].location,
              time: events[index].time,
              date: events[index].date,
              photo: events[index].photo,
              details: events[index].details,
              title: events[index].title,
            ),
          );
        },
      ),
    );
  }
}
