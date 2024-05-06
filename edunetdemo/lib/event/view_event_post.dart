import 'dart:async';
import 'package:edunetdemo/event/view_moderator_profile.dart';
import 'package:edunetdemo/razorpay/razorpay_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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

class ViewEventPost extends StatefulWidget {
  //data for likes
  bool isAdmin = false;
  final String payment;
  final String postId;
  final List<String> likes;
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

  ViewEventPost({
    required this.payment,
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
  });

  @override
  State<ViewEventPost> createState() => _ViewEventPostState();
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

class _ViewEventPostState extends State<ViewEventPost> {
  //data for likes
  final RazorPayService _razorPayService = RazorPayService();
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
    isLiked = widget.likes.contains(currentUser!.email);
    // isEnrolled = widget.enrolled.contains(currentUser!.email);
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

  void registerStudent() async {
    setState(() {
      _enrollLoading = true;
    });

    if (widget.payment != '') _paymentDialogue();

    await firestoreService.enrollStudent(
        studentId: currentUser!.email.toString(),
        moderatorId: widget.moderatorId,
        postId: widget.postId);

    setState(() {
      _enrollLoading = false;
    });
  }

  _paymentDialogue() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: ListTile(
            title: Text('Proceed to pay Rs ${widget.payment}/-'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  _razorPayService.openCheckout(int.parse(widget.payment),
                      widget.communityName, widget.eventTitle, '');
                  
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Payment Successfull'),
                  ),
                );
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: isEnrolled
                ? Text(
                    "Registered",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : SizedBox(
                    height: 38, // Set the desired height
                    child: Container(
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
                        onPressed: registerStudent,
                        child: _enrollLoading
                            ? SizedBox(
                                width:
                                    24.0, // Adjust the width and height as per your requirements
                                height: 24.0,
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                  // strokeWidth:
                                  //     3.0, // Increase or decrease this value to adjust the circle's thickness
                                ),
                              )
                            : Text(
                                "Register",
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
      body: SingleChildScrollView(
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewModeratorProfile(
                                      moderatorId: widget.moderatorId)));
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(widget.dpURL),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.communityName, // Changed
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${widget.moderatorName}', // Changed
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd  HH:mm')
                        .format(widget.timestamp.toDate()),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event    :    ${widget.eventTitle}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Date      :    ${widget.date}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Venue   :     ${widget.venue}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  widget.payment != ''
                      ? Text(
                          'Fee        :    Rs ${widget.payment}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Container()
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: widget.imageURL.isNotEmpty
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
                  isExpanded || widget.otherDetails.length <= 100
                      ? widget.otherDetails
                      : '${widget.otherDetails!.substring(0, 100)}...',
                  maxLines: isExpanded ? null : 2,
                  overflow:
                      isExpanded ? TextOverflow.clip : TextOverflow.ellipsis,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Align to the left
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: isEnrolled
                      ? Text(
                          "Already Registered",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : SizedBox(
                          height: 40, // Set the desired height
                          child: Container(
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
                              onPressed: registerStudent,
                              child: _enrollLoading
                                  ? SizedBox(
                                      width:
                                          24.0, // Adjust the width and height as per your requirements
                                      height: 24.0,
                                      child: CircularProgressIndicator(
                                        color: Colors.green,
                                        // strokeWidth:
                                        //     3.0, // Increase or decrease this value to adjust the circle's thickness
                                      ),
                                    )
                                  : Text(
                                      "Register",
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
