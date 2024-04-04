// main.dart
// import 'package:edunetdemo/alumni/alumni_dashboard.dart';
import 'package:edunetdemo/alumni/alumni_dashboard.dart';
// import 'package:edunetdemo/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
// import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.photos.request();
  await Permission.storage.request();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    // home: AuthScreen(), //EduNetApp() was here
    home: Alumni_Dashboard(),
  ));
}
