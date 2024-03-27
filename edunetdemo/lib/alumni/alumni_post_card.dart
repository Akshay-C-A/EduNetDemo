import 'package:flutter/material.dart';

class AlumniPostCard extends StatefulWidget {
  final String type;
  final String alumniName;
  final String alumniDesignation;
  final String caption;
  final String description;
  final String? imagePath;

  AlumniPostCard({
    required this.type,
    required this.alumniName,
    required this.alumniDesignation,
    required this.caption,
    required this.description,
    this.imagePath,
  });

  @override
  State<AlumniPostCard> createState() => _AlumniPostCardState();
}

class _AlumniPostCardState extends State<AlumniPostCard> {
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
                          widget.alumniName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.alumniDesignation,
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
            child: widget.imagePath != null
                ? Image.asset(
                    widget.imagePath!,
                    fit: BoxFit.cover,
                  )
                : Container(
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