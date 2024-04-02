import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  final String profileIMG;
  final String userName;
  final String caption;

  NotificationCard(
      {super.key,
      required this.profileIMG,
      required this.userName,
      required this.caption});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25,
              // backgroundImage: NetworkImage(widget.profileImageUrl),
              backgroundImage: NetworkImage(
                  'https://www.koimoi.com/wp-content/new-galleries/2023/10/shah-rukh-khan-once-destroyed-a-journalist-who-rudely-asked-him-to-be-serious-during-a-press-meet-saying-ask-me-more-i-will-answer-you-when-he-ran-out-of-questions-01.jpg'),
            ),
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
      ),
    );
  }
}
