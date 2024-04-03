import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/alumni/alumni_dashboard.dart';
import 'package:edunetdemo/alumni/alumni_edit-profile.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Alumni alumni;

  ProfilePage({required this.alumni});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alumni.alumni_name),
        actions: [
          TextButton(
            onPressed: () {
              print('LogOut');
            },
            child: Text('LogOut'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserInfoSection(alumni: widget.alumni),
            SkillsSection(skills: widget.alumni.skills),
            EmailSection(email: widget.alumni.email),
            CompanySection(company: widget.alumni.company),
            PostsSection(
              alumniId: widget.alumni.alumniId,
              firestoreService: firestoreService,
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
      },
      onLongPress: () {
        // Long press to delete the post
        _showForm();
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
