import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/auth/login_check2.dart';
import 'package:edunetdemo/event/moderator_edit-profile.dart';
import 'package:edunetdemo/event/moderator_profile_form.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Moderator {
  String moderatorId;
  String communityName;
  String moderatorName;
  String about;
  String? linkedIn;
  String? twitter;
  String? mail;
  String dpURL;

  Moderator({
    required this.moderatorId,
    required this.communityName,
    required this.moderatorName,
    required this.about,
    this.linkedIn,
    this.twitter,
    this.mail,
    required this.dpURL,
  });
}

class ModeratorProfileScreen extends StatefulWidget {
  final Moderator moderator;

  ModeratorProfileScreen({required this.moderator});

  @override
  State<ModeratorProfileScreen> createState() => _ModeratorProfileScreenState();
}

class _ModeratorProfileScreenState extends State<ModeratorProfileScreen> {
  Set<String> _selectedButton = {'Details'};

  void updateSelected(Set<String> newSelection) {
    setState(() {
      _selectedButton = newSelection;
    });
  }

  void _copyLink(String iconB) {
    if (iconB == 'LinkedIn') {
      Clipboard.setData(
          ClipboardData(text: widget.moderator.linkedIn.toString()));
    } else if (iconB == 'Twitter') {
      Clipboard.setData(
          ClipboardData(text: widget.moderator.twitter.toString()));
    } else if (iconB == 'Mail') {
      Clipboard.setData(ClipboardData(text: widget.moderator.mail.toString()));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Link copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.moderator.communityName),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  // Navigate to the MainPage
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                    (route) => false,
                  );
                } catch (e) {
                  print('Error signing out: $e');
                }
              },
              child: Text('LogOut'),
            )
          ],
        ),
        body: Stack(
          children: [
            Image.network(
              'https://firebasestorage.googleapis.com/v0/b/edunetdemo-5c098.appspot.com/o/banner%2FMODERATOR.png?alt=media&token=abaafe8e-f14a-4930-b748-2107486e42b0',
              fit: BoxFit.cover,
            ),
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, .2],
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: height * .13),
                    Padding(
                      padding:
                          EdgeInsets.fromLTRB(width * .08, 0, width * .08, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: Image.network(widget.moderator.dpURL,
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          SizedBox(width: width * .05),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    Text(
                                      widget.moderator.communityName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(widget.moderator.moderatorName),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ModeratorProfileForm(),
                                ),
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          width * .08, width * 0.03, width * .08, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\"${widget.moderator.about}\"',
                            style: TextStyle(
                                fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: width * 0.08),
                          Column(
                            children: [
                              Text(
                                'Contact :',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _copyLink('LinkedIn');
                                    },
                                    icon: Image.asset(
                                      'assets/Linkedin.png',
                                      width: 25,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _copyLink('Mail');
                                    },
                                    icon: Image.asset(
                                      'assets/Mail.png',
                                      width: 30,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _copyLink('Twitter');
                                    },
                                    icon: Image.asset(
                                      'assets/X.png',
                                      width: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: width * 0.08),
                          Center(
                            child: Text(
                              'Posts',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(height: width * 0.08),
                          PostsSection(
                            moderatorId: widget.moderator.moderatorId,
                            firestoreService: FirestoreService(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// PostsSection
class PostsSection extends StatefulWidget {
  final String moderatorId;
  final FirestoreService firestoreService;
  bool isView = false;

  PostsSection({
    required this.moderatorId,
    required this.firestoreService,
  });

  PostsSection.withView({
    required this.moderatorId,
    required this.firestoreService,
    required this.isView,
  });

  @override
  _PostsSectionState createState() => _PostsSectionState();
}

class _PostsSectionState extends State<PostsSection> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: widget.firestoreService.getModeratorProfilePosts(
            moderatorId: widget.moderatorId,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data available'));
            }

            List moderatorProfilePostList = snapshot.data!.docs;
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
              ),
              itemCount: moderatorProfilePostList.length,
              itemBuilder: (BuildContext context, int index) {
                // Get each individual doc
                DocumentSnapshot document = moderatorProfilePostList[index];
                // String docID = document.id;

                // Get note from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String? imgURL = data['imageURL'];

                // Delete post function

                return ProfileSquarePost(
                  imageURL: imgURL ?? '',
                  postId: document.id,
                  moderatorId: widget.moderatorId,
                  isView: widget.isView,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class ProfileSquarePost extends StatefulWidget {
  final String imageURL;
  final String postId;
  final String moderatorId;
  bool isView = false;

  ProfileSquarePost({
    required this.imageURL,
    required this.postId,
    required this.moderatorId,
    required this.isView,
  });

  @override
  State<ProfileSquarePost> createState() => _ProfileSquarePostState();
}

class _ProfileSquarePostState extends State<ProfileSquarePost> {
  FirestoreService firestoreService = FirestoreService();
  void _areYouSure() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
              width: double.maxFinite,
              child: ListTile(
                title: Text('Are you sure?'),
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                firestoreService.deleteEventPost(
                    moderatorId: widget.moderatorId, postId: widget.postId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Post Deleted'),
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

  void _showForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Options'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModeratorEditPostForm(
                                moderatorId: widget.moderatorId,
                                postId: widget.postId)));
                  },
                  child: ListTile(
                    title: Text('Edit Post'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _areYouSure();
                    // Navigator.of(context).pop();
                  },
                  child: ListTile(
                    title: Text('Delete Post'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
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
    return GestureDetector(
      onTap: () {
        // Handle tap if needed
        if (!widget.isView) {
          _showForm();
        }
      },
      onLongPress: () {
        // Long press to delete the post

        // showDialog(
        //     context: context,
        //     builder: (context) => Dialog(
        //           child: Container(
        //             height: MediaQuery.of(context).size.height * .2,
        //             child: Text('Sample Text'),
        //           ),
        //         ));
      },
      child: Card(
        margin: EdgeInsets.all(2.0),
        elevation: 5.0,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: widget.imageURL.isNotEmpty
              ? Image.network(
                  widget.imageURL,
                  fit: BoxFit.cover,
                )
              : Container(child: Icon(Icons.abc)),
        ),
      ),
    );
  }
}
