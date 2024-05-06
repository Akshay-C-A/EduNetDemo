import 'package:edunetdemo/auth/login_check2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SuspendedPage extends StatelessWidget {
  const SuspendedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suspended'),
        actions: [
          IconButton(
            onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  // Navigate to the MainPage
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                    (route) => false,
                  );
                } catch (e) {
                  print('Error signing out: $e');
                }
              },
         icon: Icon(Icons.logout)
          ),
        ],

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.block,
              size: 80,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Your account has been suspended.',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Please contact the administrator for more information.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}