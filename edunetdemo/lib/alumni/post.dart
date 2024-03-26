import 'package:flutter/material.dart';

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text('Posts'),
//       ),
//       body: PostCardList(),
//     ),
//   ));
// }

class PostCardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        PostCard(
          adminName: 'John Doe',
          adminDesignation: 'Software Engineer',
          caption: 'Amazing post!',
          description: 'This is the description of the post.',
          // imagePath: 'assets/images/post_image.jpg', // You can provide imagePath here
        ),
        PostCard(
          adminName: 'Jane Smith',
          adminDesignation: 'Designer',
          caption: 'Awesome day!',
          description: 'Had a great time with friends.',
          // imagePath: 'assets/images/another_post_image.jpg', // You can provide imagePath here
        ),
        // Add more PostCard widgets as needed
      ],
    );
  }
}

class PostCard extends StatelessWidget {
  final String adminName;
  final String adminDesignation;
  final String caption;
  final String description;
  final String? imagePath;

  PostCard({
    required this.adminName,
    required this.adminDesignation,
    required this.caption,
    required this.description,
    this.imagePath,
  });

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
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          adminName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          adminDesignation,
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
              caption,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: imagePath != null
                ? Image.asset(
                    imagePath!,
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
            padding: EdgeInsets.all(10.0),
            child: Text(description),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {},
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