// ignore_for_file: prefer_final_fields, non_constant_identifier_names

import 'package:edunetdemo/alumni/alumni_newpost.dart';
import 'package:edunetdemo/alumni/alumni_notification.dart';
import 'package:edunetdemo/alumni/alumni_profile.dart';
import 'package:edunetdemo/common_pages/alumni_page.dart';
import 'package:edunetdemo/common_pages/student_page.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Alumni {
  String alumniId;
  String alumni_name;
  String alumni_designation;
  List<dynamic> skills;
  String about;
  String company;
  String? linkedIn;
  String? twitter;
  String? mail;
  String dpURL;

  Alumni({
    required this.alumniId,
    required this.alumni_name,
    required this.alumni_designation,
    required this.skills,
    required this.about,
    required this.company,
    this.linkedIn,
    this.twitter,
    this.mail,
    required this.dpURL,
  });
}

class Alumni_Dashboard extends StatefulWidget {
  const Alumni_Dashboard({
    super.key,
  });

  @override
  State<Alumni_Dashboard> createState() => _Alumni_DashboardState();
}

class _Alumni_DashboardState extends State<Alumni_Dashboard> {
  final FirestoreService _firestoreService = FirestoreService();
  final currentUser = FirebaseAuth.instance.currentUser;

  late String alumni_name = 'john doe';
  late String alumni_designation = 'CS Engineer';
  late List<dynamic> skills = ['null'];
  late String alumniId = 'john_doe';
  late String about = 'eg';
  late String company = 'eg';
  late String? linkedIn = 'eg';
  late String? twitter = 'eg';
  late String? mail = 'eg';
  late String dpURL = 'eg';

  Map<String, dynamic>? _postData;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  int _selectedIndex = 0;

  Future<void> _fetchDetails() async {
    final alumniId = currentUser!.email;
    final postSnapshot = await _firestoreService.getAlumni(
      alumniId: alumniId,
    );

    if (postSnapshot.exists) {
      setState(() async {
        _postData = postSnapshot.data() as Map<String, dynamic>;

        alumni_name = _postData!['alumniName'] as String;
        alumni_designation = _postData!['alumniDesignation'] as String;
        skills = (_postData!['skills'] as List<dynamic>).cast<String>();
        about = _postData!['about'] as String;
        company = _postData!['company'] as String;
        linkedIn = _postData!['linkedIn'] as String;
        twitter = _postData!['twitter'] as String;
        mail = _postData!['mail'] as String;
        dpURL = _postData!['dpURL'] as String;
      });
    } else {
      // Handle the case when the post is not found
      setState(() {
        _postData = null;
        alumni_name = 'john doe';
        alumni_designation = 'CS Engineer';
        skills = ['null'];
        about = 'eg';
        company = 'eg';
        linkedIn = 'eg';
        twitter = 'eg';
        mail = 'eg';
        dpURL = 'eg';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account details not found'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      AlumniPage(
          alumni: Alumni(
        alumni_name: alumni_name,
        alumniId: alumniId,
        alumni_designation: alumni_designation,
        skills: skills,
        about: about,
        company: company,
        linkedIn: linkedIn,
        twitter: twitter,
        mail: mail,
        dpURL: dpURL,
      )),
      StudentPage(),
      AlumniNewPostPage(
          alumni: Alumni(
        alumni_name: alumni_name,
        alumniId: alumniId,
        alumni_designation: alumni_designation,
        skills: skills,
        about: about,
        company: company,
        linkedIn: linkedIn,
        twitter: twitter,
        mail: mail,
        dpURL: dpURL,
      )),
      AlumniNotification(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Alumni'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                        alumni: Alumni(
                      alumni_name: alumni_name,
                      alumniId: alumniId,
                      alumni_designation: alumni_designation,
                      skills: skills,
                      about: about,
                      company: company,
                      linkedIn: linkedIn,
                      twitter: twitter,
                      mail: mail,
                      dpURL: dpURL,
                    )),
                  ));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                //backgroundImage: NetworkImage('https://example.com/profile.jpg'),
                radius: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fetchDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return IndexedStack(
              index: _selectedIndex,
              children: widgetOptions,
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
        ],
      ),
    );
  }
}



// late Alumni alumni = alumni = Alumni(
//     alumniId: 'john_doe',
//     alumni_name: 'John Doe',
//     alumni_designation: 'CS Engineer',
//     skills: ['Flutter', 'Django', 'C', 'C++'],
//     mail: '1',
//     company: 'WIPRO',
//     // alumniId: _postData!['alumniId'] as String,
//     // alumni_name: _postData!['alumniName'] as String,
//     // alumni_designation: _postData!['alumniDesignation'] as String,
//     // skills: (_postData!['skills'] as List<dynamic>).cast<String>(),
//     about: 'fddhsdh',
//     // company: _postData!['company'] as String,
//     // linkedIn: _postData!['linkedIn'] as String,
//     // twitter: _postData!['twitter'] as String,
//     // mail: _postData!['mail'] as String,
//     dpURL:
//         'data:image/jpeg;base64,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',
//   );