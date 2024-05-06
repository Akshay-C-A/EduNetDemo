import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';



class StudentViewPost extends StatefulWidget {
  //data for likes
  final String postId;
  final List<String> likes;

  final String studentId;
  bool isAdmin = false;
  final String studentName;
  final String studentDesignation;
  final String caption;
  final String description;
  final String imageURL;
  final String dpURL;
  final DateTime timestamp;

  StudentViewPost({
     required this.isAdmin,
    required this.studentId,
    required this.studentName,
    required this.studentDesignation,
    required this.caption,
    required this.description,
    required this.imageURL,
    required this.dpURL,
    required this.postId,
    required this.likes,
    required this.timestamp,
  });

  @override
  _StudentViewPostState createState() => _StudentViewPostState();
}

Future<void> _downloadImageToGallery(String imageURL) async {
  try {
    // Get the directory for saving the image
    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      // Create the file path
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      File file = File('${directory.path}/$fileName');

      // Download the image
      var response = await http.get(Uri.parse(imageURL));
      await file.writeAsBytes(response.bodyBytes);

      // Add the image to the device's gallery
      final result = await ImageGallerySaver.saveFile(file.path);
      print('Image saved to gallery: $result');
    }
  } catch (e) {
    print('Error downloading image: $e');
  }
}
class _StudentViewPostState extends State<StudentViewPost> {
  //data for likes
  final FirestoreService firestoreService = FirestoreService();
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;

  bool isExpanded = false;
  bool showLikeIcon = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser!.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    List ref = firestoreService.studentPostInstances(
        postId: widget.postId, studentId: widget.studentId);
    DocumentReference studentPost = ref[0];
    DocumentReference studentProfile = ref[1];

    if (isLiked) {
      studentPost.update({
        'likes': FieldValue.arrayUnion([currentUser!.email])
      });
      studentProfile.update({
        'likes': FieldValue.arrayUnion([currentUser!.email])
      });
    } else {
      studentPost.update({
        'likes': FieldValue.arrayRemove([currentUser!.email])
      });
      studentProfile.update({
        'likes': FieldValue.arrayRemove([currentUser!.email])
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.dpURL),
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
                      SizedBox(height: 4),
                      Text(
                        widget.timestamp.toString(), // Adjust date formatting as needed
                        style: TextStyle(color: Colors.grey),
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
  child: GestureDetector(
    onDoubleTap: toggleLike, // Add onDoubleTap callback here
    child: widget.imageURL!.isNotEmpty
        ? Image.network(
            widget.imageURL,
            fit: BoxFit.cover,
          )
        : Container(),
  ),
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
                      isExpanded || widget.description.length <= 100
                          ? widget.description
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
                Column(
                  children: [
                    GestureDetector(
                      onTap: toggleLike,
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.likes.length.toString(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      child: Icon(Icons.send),
                      onTap: () async {
                        // Implement share functionality
                          final tempDir = await getTemporaryDirectory();
                            final tempFile =
                                File('${tempDir.path}/shared_image.jpg');

                            // Download the image to the temporary file
                            var response =
                                await http.get(Uri.parse(widget.imageURL));
                            await tempFile.writeAsBytes(response.bodyBytes);

                            // Share the image and other details
                            await Share.shareXFiles(
                              [XFile(tempFile.path)],
                              text:
                                  '${widget.studentName} shared a post:\n\n${widget.caption}\n\n${widget.description}',
                            );
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Share',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      child: Icon(Icons.bookmark_border),
                      onTap: () async {
                        // Implement save functionality
                        PermissionStatus status =
                                await Permission.storage.request();
                            if (status.isGranted) {
                              // Download the image to the gallery
                              await _downloadImageToGallery(widget.imageURL);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Image downloaded to gallery'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Permission denied to access storage'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Save',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class LikeButton extends StatelessWidget {
  final bool isLiked;
  final void Function()? onTap;
  LikeButton({Key? key, required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey,
      ),
    );
  }
}