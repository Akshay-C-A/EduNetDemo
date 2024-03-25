// src/screens/dashboard/moderator_dashboard.dart
import 'package:flutter/material.dart';

class ModeratorDashboard extends StatelessWidget {
  const ModeratorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Moderator Dashboard',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          Text(
            'Implement moderator-specific features here',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}