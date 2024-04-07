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
  late String alumniId;
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
    alumniId = currentUser!.email!;
    final postSnapshot = await _firestoreService.getAlumni(
      alumniId: alumniId.toString(),
    );

    Map<String, dynamic>? postData;
    if (postSnapshot.exists) {
      postData = postSnapshot.data() as Map<String, dynamic>;
    } else {
      // Handle the case when the post is not found
      postData = null;
    }

    if (postData != null) {
      alumni_name = postData['alumniName'] as String;
      alumni_designation = postData['alumniDesignation'] as String;
      alumniId = currentUser!.email!;
      skills = (postData['skills'] as List<dynamic>).cast<String>();
      about = postData['about'] as String;
      company = postData['company'] as String;
      linkedIn = postData['linkedIn'] as String;
      twitter = postData['twitter'] as String;
      mail = postData['mail'] as String;
      dpURL = postData['dpURL'] as String;
    } else {
      alumni_name = 'john doe';
      alumni_designation = 'CS Engineer';
      skills = ['null'];
      about = 'eg';
      company = 'eg';
      linkedIn = 'eg';
      twitter = 'eg';
      mail = 'eg';
      dpURL = 'eg';

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
                backgroundImage: NetworkImage(dpURL),
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


  // Future<void> _fetchDetails() async {
  //   final alumniId = currentUser!.email;
  //   final postSnapshot = await _firestoreService.getAlumni(
  //     alumniId: alumniId,
  //   );

  //   if (postSnapshot.exists) {
  //     setState(() async {
  //       _postData = postSnapshot.data() as Map<String, dynamic>;

  //       alumni_name = _postData!['alumniName'] as String;
  //       alumni_designation = _postData!['alumniDesignation'] as String;
  //       skills = (_postData!['skills'] as List<dynamic>).cast<String>();
  //       about = _postData!['about'] as String;
  //       company = _postData!['company'] as String;
  //       linkedIn = _postData!['linkedIn'] as String;
  //       twitter = _postData!['twitter'] as String;
  //       mail = _postData!['mail'] as String;
  //       dpURL = _postData!['dpURL'] as String;
  //     });
  //   } else {
  //     // Handle the case when the post is not found
  //     setState(() {
  //       _postData = null;
  //       alumni_name = 'john doe';
  //       alumni_designation = 'CS Engineer';
  //       skills = ['null'];
  //       about = 'eg';
  //       company = 'eg';
  //       linkedIn = 'eg';
  //       twitter = 'eg';
  //       mail = 'eg';
  //       dpURL = 'eg';
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Account details not found'),
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //   }
  // }
