import 'dart:async';

import 'package:flutter/material.dart';

class AlumniPostCard extends StatefulWidget {
  final String type;
  final String alumniName;
  final String alumniDesignation;
  final String caption;
  final String description;
  final String imageURL;

  AlumniPostCard({
    required this.type,
    required this.alumniName,
    required this.alumniDesignation,
    required this.caption,
    required this.description,
    required this.imageURL,
  });

  @override
  State<AlumniPostCard> createState() => _AlumniPostCardState();
}

class _AlumniPostCardState extends State<AlumniPostCard> {
  bool isLiked = false;
  bool isExpanded = false;
  bool showLikeIcon = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          isLiked = !isLiked;
          showLikeIcon = true;
        });
        Timer(Duration(milliseconds: 500), () {
          setState(() {
            showLikeIcon = !showLikeIcon;
          });
        });
      },
      child: Card(
        margin: EdgeInsets.all(10.0),
        elevation: 5.0,
        child: Stack(
          children: [
            Column(
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
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
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
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      isExpanded ||
                              widget.description == null ||
                              widget.description!.length <= 100
                          ? widget.description ?? 'No description available'
                          : '${widget.description!.substring(0, 100)}...',
                      maxLines: isExpanded ? null : 2,
                      overflow: isExpanded
                          ? TextOverflow.clip
                          : TextOverflow.ellipsis,
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked
                            ? const Color.fromARGB(255, 201, 55, 45)
                            : null,
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
            if (showLikeIcon)
              Positioned.fill(
                child: Container(
                  child: Center(
                    child: Icon(
                      Icons.favorite,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      size: 100,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
