// main.dart
import 'package:edunetdemo/alumni/alumni_dashboard.dart';
// import 'app.dart';
import 'package:edunetdemo/auth/login_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
<<<<<<< HEAD
 //import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Permission.photos.request();
   await Permission.storage.request();
=======
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.photos.request();
  await Permission.storage.request();

>>>>>>> 59b269f8cc5437b3649abea0985cce3e05bda0e2
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  runApp(MaterialApp(
    // home: Alumni_Dashboard(),
    home: const MainPage(),
  ));
}
