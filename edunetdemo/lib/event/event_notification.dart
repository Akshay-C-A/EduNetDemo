import 'package:flutter/material.dart';

class EventNotificationPage extends StatefulWidget {
  const EventNotificationPage({super.key});

  @override
  State<EventNotificationPage> createState() => _EventNotificationPageState();
}

class _EventNotificationPageState extends State<EventNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('This is the notifications'),
      ),
    );
  }
}