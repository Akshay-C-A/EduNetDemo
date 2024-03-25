// src/screens/dashboard/student_dashboard.dart
import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Student Dashboard',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          Text(
            'Implement student-specific features here',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}