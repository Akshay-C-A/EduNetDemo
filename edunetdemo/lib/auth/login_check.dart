// import 'package:edunetdemo/alumni/alumni_dashboard.dart';
// import 'package:edunetdemo/auth/profile_form.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'home_page.dart';
// import 'login_page.dart';

// class MainPage extends StatelessWidget {
//   const MainPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             // User is logged in, navigate to the AlumniDashboard
//             return ProfileForm();
//             // Alumni_Dashboard(
//             //     alumni: Alumni(
//             //         alumniId: 'john_doe',
//             //         alumni_name: 'John Doe',
//             //         alumni_designation: 'CS Engineer',
//             //         skills: ['Flutter', 'Django', 'C', 'C++'],
//             //         email: '1',
//             //         company: 'WIPRO',
//             //         alumni_dept: 'CS'));
//           } else {
//             // User is not logged in, navigate to the LoginPage
//             return LoginPage();
//           }
//         },
//       ),
//     );
//   }
// }

//profile_check.dart

//profile_check.dart

import 'package:edunetdemo/alumni/alumni_dashboard.dart';
import 'package:edunetdemo/auth/login_page.dart';
import 'package:edunetdemo/auth/profile_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edunetdemo/services/firestore.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            // User is logged in, check if their email is in the Firestore database
            return FutureBuilder(
              future: _firestoreService.getAlumniByEmail(snapshot.data!.email!),
              builder: (context, alumniSnapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                  child: CircularProgressIndicator(),
                 );
                }
                else if (alumniSnapshot.hasData && alumniSnapshot.data != null) {
                  // User's email is in the Firestore database, navigate to the alumni dashboard
                  return Alumni_Dashboard(
                    // alumni: alumniSnapshot.data!,
                  );
                } 
                else {
                  // User's email is not in the Firestore database, navigate to the profile form
                  return ProfileForm();
                }
              },
            );
          } else {
            // User is not logged in, navigate to the LoginPage
            return LoginPage();
          }
        },
      ),
    );
  }
}