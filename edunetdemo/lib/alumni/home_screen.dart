
// src/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:edunetdemo/alumni/student_dashboard.dart';
import 'package:edunetdemo/alumni/alumni_dashboard.dart';
import 'package:edunetdemo/alumni/moderator_dashboard.dart';
import 'package:edunetdemo/alumni/admin_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _dashboards = [
    const StudentDashboard(),
    const AlumniDashboard(),
    const ModeratorDashboard(),
    const AdminDashboard(),
  ];

  @override
  void initState() {
    super.initState();
    _determineUserRole();
  }

  Future<void> _determineUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Determine user role based on user data from Firebase
      // and update _currentIndex accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EduNet'),
      ),
      body: _dashboards[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Student',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Alumni',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_moderator),
            label: 'Moderator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
        ],
      ),
    );
  }
}

