// import 'package:edunetdemo/alumni/alumni_dashboard.dart';

import 'package:edunetdemo/auth/login_check2.dart';
import 'package:edunetdemo/services/notification_services.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.photos.request();
  await Permission.storage.request();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initNotification();

  await FirebaseAppCheck.instance.activate();
  runApp(MaterialApp(
    // home: Alumni_Dashboard(),
    home: const MainPage(),
  ));
}
