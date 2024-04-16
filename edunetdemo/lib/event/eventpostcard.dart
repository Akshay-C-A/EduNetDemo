import 'package:flutter/material.dart';

class EventPostCard extends StatefulWidget {
  final String location;
  final String time;
  final String date;
  final String photo;
  final String details;
  final String title;

  EventPostCard({
    required this.location,
    required this.time,
    required this.date,
    required this.photo,
    required this.details,
    required this.title,
  });

  @override
  State<EventPostCard> createState() => _PostCardState();
}

class _PostCardState extends State<EventPostCard> {
  bool isLoved = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 5.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey, // Placeholder color
                      child: Text(
                        widget.title[0].toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${widget.date}, ${widget.time}, ${widget.location}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                PopupMenuButton(
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Option 1'),
                      value: 'option1',
                    ),
                    PopupMenuItem(
                      child: Text('Option 2'),
                      value: 'option2',
                    ),
                    PopupMenuItem(
                      child: Text('Option 3'),
                      value: 'option3',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              widget.details,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              height: 200,
              color: Colors.grey[300],
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(widget.details),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isLoved = !isLoved;
                  });
                },
                icon: Stack(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: isLoved ? Colors.red : Colors.black,
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.favorite,
                          color: isLoved ? Colors.red : Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

