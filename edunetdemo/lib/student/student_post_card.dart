import 'package:flutter/material.dart';

class StudentPostCard extends StatefulWidget {
  //data for likes
  final String postId;
  final List<String> likes;

  //data for post
  final String studentId;
  final String studentName;
  final String studentDesignation;
  
  final String caption;
  final String description;
  final String imageURL;
  final String dpURL;

  StudentPostCard({
   required this.studentId,
    required this.studentName,
    required this.studentDesignation,
    
    required this.caption,
    required this.description,
    required this.imageURL,
    required this.dpURL,
    required this.postId,
    required this.likes,
  });

  @override
  State<StudentPostCard> createState() => _PostCardState();
}

class _PostCardState extends State<StudentPostCard> {
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
                      backgroundImage: NetworkImage(widget.dpURL), // Placeholder color
                     
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
            padding: EdgeInsets.all(10.0),
            child: Text(widget.description),
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

