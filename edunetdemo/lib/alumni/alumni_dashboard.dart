
import 'package:edunetdemo/alumni/alumni_newpost.dart';
import 'package:edunetdemo/alumni/alumni_notification.dart';
import 'package:edunetdemo/common_pages/alumni_page.dart';
import 'package:edunetdemo/common_pages/student_page.dart';
import 'package:flutter/material.dart';

class Alumni_Dashboard extends StatefulWidget {
  const Alumni_Dashboard({super.key});

  @override
  State<Alumni_Dashboard> createState() => _Alumni_DashboardState();
}

class _Alumni_DashboardState extends State<Alumni_Dashboard> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    AlumniPage(),
    StudentPage(),
    AlumniNewPostPage(),
    AlumniNotification(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
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
