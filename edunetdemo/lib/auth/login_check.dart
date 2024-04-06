import 'package:edunetdemo/alumni/alumni_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'login_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // User is logged in, navigate to the AlumniDashboard
            return Alumni_Dashboard();
          } else {
            // User is not logged in, navigate to the LoginPage
            return LoginPage();
          }
        },
      ),
    );
  }
}