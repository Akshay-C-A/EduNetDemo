import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/alumni/alumni_dashboard.dart';
import 'package:edunetdemo/alumni/alumni_edit-profile.dart';
import 'package:edunetdemo/alumni/alumni_post_card.dart';
import 'package:edunetdemo/auth/login_check.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final Alumni alumni;

  ProfileScreen({required this.alumni});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedButton = 'Details';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.alumni.alumni_name),
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
              'https://marketplace.canva.com/EAE1oe3H6Sc/1/0/1600w/canva-black-elegant-minimalist-profile-linkedin-banner-nc0eALdRvKU.jpg',
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
                                child: Image.network(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRMUD7t-efVsZcOQIrC6FzYqdfaIGrpl_BkkvIHEGlAtw&s',
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
                                      widget.alumni.alumni_name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(widget.alumni.alumni_designation),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileForm(),
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
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                            style: TextStyle(
                              fontSize: 16,
                            ),
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
                                  Icon(
                                    Icons.phone,
                                    size: 30,
                                  ),
                                  Icon(
                                    Icons.email,
                                    size: 30,
                                  ),
                                  Icon(
                                    Icons.location_on,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: width * 0.08),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedButton = 'Details';
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: _selectedButton == 'Details'
                                      ? Colors.blue
                                      : Colors.black,
                                  textStyle: TextStyle(
                                    decoration: _selectedButton == 'Details'
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                    decorationThickness: 2.0,
                                  ),
                                ),
                                child: Text('Details'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedButton = 'Posts';
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: _selectedButton == 'Posts'
                                      ? Colors.blue
                                      : Colors.black,
                                  textStyle: TextStyle(
                                    decoration: _selectedButton == 'Posts'
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                    decorationThickness: 2.0,
                                  ),
                                ),
                                child: Text('Posts'),
                              ),
                            ],
                          ),
                          if (_selectedButton == 'Details')
                            Column(
                              children: [
                                SkillsSection(skills: widget.alumni.skills),
                                // EmailSection(email: widget.alumni.email),
                                CompanySection(company: widget.alumni.company),
                              ],
                            )
                          else
                            PostsSection(
                              alumniId: widget.alumni.alumniId,
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

class UserInfoSection extends StatelessWidget {
  final Alumni alumni;

  UserInfoSection({required this.alumni});

  @override
  Widget build(BuildContext context) {
    Color color2566be = Color(0xFF2566BE);
    LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color2566be.withOpacity(0.5),
        color2566be,
      ],
    );

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 60,
            // backgroundImage: AssetImage('assets/profile_photo.jpg'),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alumni.alumni_name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  alumni.alumni_designation,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  'Posts: 100',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileForm(),
                ),
              );
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}

// SkillsSection
class SkillsSection extends StatelessWidget {
  final List<String> skills;

  SkillsSection({required this.skills});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 5),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: skills
                .map((skill) => Chip(
                      label: Text(skill),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// EmailSection
class EmailSection extends StatelessWidget {
  final String email;

  EmailSection({required this.email});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 5),
          Text(
            email,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// CompanySection
class CompanySection extends StatelessWidget {
  final String company;

  CompanySection({required this.company});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Company',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 5),
          Text(
            company,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// PostsSection
class PostsSection extends StatefulWidget {
  final String alumniId;
  final FirestoreService firestoreService;

  PostsSection({
    required this.alumniId,
    required this.firestoreService,
  });

  @override
  _PostsSectionState createState() => _PostsSectionState();
}

class _PostsSectionState extends State<PostsSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Posts',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: widget.firestoreService.getAlumniProfilePosts(
              alumniId: widget.alumniId,
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

              List alumniProfilePostList = snapshot.data!.docs;
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                ),
                itemCount: alumniProfilePostList.length,
                itemBuilder: (BuildContext context, int index) {
                  // Get each individual doc
                  DocumentSnapshot document = alumniProfilePostList[index];
                  // String docID = document.id;

                  // Get note from each doc
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String? imgURL = data['imageURL'];

                  // Delete post function
                  void deletePost() {
                    setState(() {
                      alumniProfilePostList.removeAt(index);
                    });
                  }

                  return ProfileSquarePost(
                    imageURL: imgURL ?? '',
                    postId: document.id,
                    alumniId: widget.alumniId,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProfileSquarePost extends StatefulWidget {
  final String imageURL;
  final String postId;
  final String alumniId;

  const ProfileSquarePost({
    required this.imageURL,
    required this.postId,
    required this.alumniId,
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
                firestoreService.deletePost(
                    alumniId: widget.alumniId, postId: widget.postId);
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
                            builder: (context) => EditPostForm(
                                alumniId: widget.alumniId,
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
        _showForm();
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
