// src/screens/dashboard/alumni_dashboard.dart
import 'package:flutter/material.dart';

class AlumniDashboard extends StatelessWidget {
  const AlumniDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Alumni Dashboard',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          Text(
            'Implement alumni-specific features here',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}