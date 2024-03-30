import 'package:flutter/material.dart';

class StudentPostCard extends StatefulWidget {
  final String type;
  final String studentName;
  final String studentDesignation;
  final String caption;
  final String description;
  final String imageURL;

  StudentPostCard({
    required this.type,
    required this.studentName,
    required this.studentDesignation,
    required this.caption,
    required this.description,
    required this.imageURL,
  });

  @override
  State<StudentPostCard> createState() => _AlumniPostCardState();
}

class _AlumniPostCardState extends State<StudentPostCard> {
  bool isLiked = false;

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
                      //backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.studentName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.studentDesignation,
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
              widget.caption,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: widget.imageURL!.isNotEmpty
                ? Image.network(
                    widget.imageURL,
                    fit: BoxFit.cover,
                  )
                : Container(),
          ),
          Padding(
            // padding: EdgeInsets.all(10.0),
            // child: Text(description[20]),
            padding: EdgeInsets.all(10.0),
            child: Text(
              widget.description.length > 50
                  ? '${widget.description.substring(0, 100)}...'
                  : widget.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color:
                      isLiked ? const Color.fromARGB(255, 201, 55, 45) : null,
                ),
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
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
