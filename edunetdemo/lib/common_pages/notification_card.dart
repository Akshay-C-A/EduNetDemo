import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatefulWidget {
  final String userName;
  final String caption;
  final String dpURL;
  final Timestamp timestamp;

  NotificationCard(
      {super.key,
      required this.userName,
      required this.caption,
      required this.timestamp,
      required this.dpURL, 
      // required Timestamp timestamp
      });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: 25,
                    // backgroundImage: NetworkImage(widget.profileImageUrl),
                    backgroundImage: NetworkImage(widget.dpURL)),
                    SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  
                ),
                SizedBox(height: 5),
                Text(
                  widget.caption,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            
                 
              ],
            ),
            SizedBox(height: 4,),
                              Text(
                  DateFormat('yyyy-MM-dd  HH:mm').format(widget.timestamp.toDate()),
                  style: TextStyle(color: Colors.black),
                          ),
          ],
        ),
      ),
    );
  }
}
