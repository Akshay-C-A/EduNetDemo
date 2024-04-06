// ignore_for_file: prefer_final_fields

import 'package:edunetdemo/alumni/alumni_newpost.dart';
import 'package:edunetdemo/alumni/alumni_notification.dart';
import 'package:edunetdemo/alumni/alumni_profile.dart';
import 'package:edunetdemo/common_pages/alumni_page.dart';
import 'package:edunetdemo/common_pages/student_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Alumni {
  final String alumniId;
  final String alumni_name;
  final String alumni_designation;
  final List<String> skills;
  final String email;
  final String company;
  final String alumni_dept;

  Alumni({
    required this.alumniId,
    required this.alumni_name,
    required this.alumni_designation,
    required this.skills,
    required this.email,
    required this.company,
    required this.alumni_dept,
  });
}

class Alumni_Dashboard extends StatefulWidget {
  final Alumni alumni;
  const Alumni_Dashboard({super.key, required this.alumni});

  @override
  State<Alumni_Dashboard> createState() => _Alumni_DashboardState();
}

class _Alumni_DashboardState extends State<Alumni_Dashboard> {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      AlumniPage(alumni: widget.alumni),
      StudentPage(),
      AlumniNewPostPage(alumni: widget.alumni),
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
                    builder: (context) => ProfileScreen(alumni: widget.alumni),
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
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: widgetOptions,
        ),
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
