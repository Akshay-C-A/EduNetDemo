import 'dart:async';
import 'package:edunetdemo/event/view_event_post.dart';
import 'package:edunetdemo/event/view_moderator_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventPostCard extends StatefulWidget {
  //data for likes
  bool isAdmin = false;
  final String postId;
  final List<String> likes;
  final List<String> enrolled;
  final String communityName;
  final String venue;
  final String moderatorId;
  final String date;
  final String moderatorName;
  final String otherDetails;
  final String eventTitle;
  final String imageURL;
  final String dpURL;
  final Timestamp timestamp;
  final String payment;

  EventPostCard({
    required this.isAdmin,
    required this.venue,
    required this.moderatorId,
    required this.moderatorName,
    required this.otherDetails,
    required this.eventTitle,
    required this.date,
    required this.communityName,
    required this.imageURL,
    required this.dpURL,
    required this.postId,
    required this.likes,
    required this.timestamp,
    required this.payment,
    required this.enrolled,
  });

  @override
  State<EventPostCard> createState() => _EventPostCardState();
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

class _EventPostCardState extends State<EventPostCard>
    with WidgetsBindingObserver {
  //data for likes
  final FirestoreService firestoreService = FirestoreService();
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isLiked = false;
  bool isExpanded = false;
  bool showLikeIcon = false;
  bool _enrollLoading = false;
  bool isEnrolled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    isLiked = widget.likes.contains(currentUser!.email);
    print(widget.likes);
    isEnrolled = widget.enrolled.contains(currentUser!.email);
    print(widget.enrolled);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    // TODO: implement didPopRoute
    isEnrolled = widget.enrolled.contains(currentUser!.email);
    return true;
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    List ref = firestoreService.eventPostInstances(
        postId: widget.postId, moderatorId: widget.moderatorId);
    DocumentReference eventPost = ref[0];
    DocumentReference moderatorProfile = ref[1];

    if (isLiked) {
      eventPost.update({
        'likes': FieldValue.arrayUnion([currentUser!.email])
      });
      moderatorProfile.update({
        'likes': FieldValue.arrayUnion([currentUser!.email])
      });
    } else {
      eventPost.update({
        'likes': FieldValue.arrayRemove([currentUser!.email])
      });
      moderatorProfile.update({
        'likes': FieldValue.arrayRemove([currentUser!.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => ViewEventPost(
                      payment: widget.payment,
                      isAdmin: widget.isAdmin,
                      venue: widget.venue,
                      moderatorId: widget.moderatorId,
                      moderatorName: widget.moderatorName,
                      otherDetails: widget.otherDetails,
                      eventTitle: widget.eventTitle,
                      date: widget.date,
                      communityName: widget.communityName,
                      imageURL: widget.imageURL,
                      dpURL: widget.dpURL,
                      postId: widget.postId,
                      likes: widget.likes,
                      timestamp: widget.timestamp,
                      enrolled: widget.enrolled,
                    ))));
      },
      onDoubleTap: () {
        setState(() {
          toggleLike();
          showLikeIcon = true;
        });
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            showLikeIcon = !showLikeIcon;
          });
        });
      },
      child: Card(
        margin: const EdgeInsets.all(10.0),
        elevation: 5.0,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewModeratorProfile(
                                              moderatorId:
                                                  widget.moderatorId)));
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(widget.dpURL),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.communityName, // Changed
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.moderatorName}', // Changed
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                DateFormat('yyyy-MM-dd  HH:mm')
                                    .format(widget.timestamp.toDate()),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event     :    ${widget.eventTitle}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date      :    ${widget.date}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Venue   :     ${widget.venue}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      widget.payment != ''
                          ? Text(
                              'Fee        :    Rs ${widget.payment}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Container()
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: widget.imageURL!.isNotEmpty
                      ? Image.network(
                          widget.imageURL,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      isExpanded || widget.otherDetails.length <= 100
                          ? widget.otherDetails
                          : '${widget.otherDetails.substring(0, 80)}...read more',
                      maxLines: isExpanded ? null : 2,
                      overflow: isExpanded
                          ? TextOverflow.clip
                          : TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Align to the left
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 40, // Set the desired height
                        child: isEnrolled
                            ? const Text(
                                "You are already enrolled in this event",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Reduce the curve size
                                ),
                                // Add horizontal padding
                                child: TextButton(
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                ViewEventPost(
                                                    enrolled: widget.enrolled,
                                                    payment: widget.payment,
                                                    isAdmin: widget.isAdmin,
                                                    venue: widget.venue,
                                                    moderatorId:
                                                        widget.moderatorId,
                                                    moderatorName:
                                                        widget.moderatorName,
                                                    otherDetails:
                                                        widget.otherDetails,
                                                    eventTitle:
                                                        widget.eventTitle,
                                                    date: widget.date,
                                                    communityName:
                                                        widget.communityName,
                                                    imageURL: widget.imageURL,
                                                    dpURL: widget.dpURL,
                                                    postId: widget.postId,
                                                    likes: widget.likes,
                                                    timestamp:
                                                        widget.timestamp))));
                                  },
                                  child: const Text(
                                    "Enroll",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    color: Colors.grey[350],
                    height: 2,
                    width: MediaQuery.of(context).size.width * 0.85,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        //like button
                        LikeButton(isLiked: isLiked, onTap: toggleLike),

                        const SizedBox(
                          height: 5,
                        ),

                        //like count
                        Text(
                          widget.likes.length.toString(),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.send),
                          onTap: () async {
                            // Create a temporary file to store the image
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
                                  '${widget.communityName} shared a post:\n\n${widget.eventTitle}\n\n${widget.eventTitle}\n\n${widget.venue}\n\n${widget.otherDetails}',
                            );
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Share',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.bookmark_border),
                          onTap: () async {
                            // Check and request storage permission
                            PermissionStatus status =
                                await Permission.storage.request();
                            if (status.isGranted) {
                              // Download the image to the gallery
                              await _downloadImageToGallery(widget.imageURL);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Image downloaded to gallery'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Permission denied to access storage'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Save',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            if (showLikeIcon)
              Positioned.fill(
                child: Container(
                  child: const Center(
                    child: Icon(
                      Icons.favorite,
                      color: Color.fromARGB(255, 255, 255, 255),
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
