// src/app.dart
import 'package:flutter/material.dart';
import 'package:edunetdemo/auth_screen.dart';
import 'package:edunetdemo/alumni/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EduNetApp extends StatelessWidget {
  const EduNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduNet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          } else if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}