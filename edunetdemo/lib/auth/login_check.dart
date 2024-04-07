import 'package:edunetdemo/alumni/alumni_dashboard.dart';
import 'package:edunetdemo/auth/profile_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'login_page.dart';

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
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  Future<bool> _hasCompletedProfileForm() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasCompletedProfileForm') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // User is logged in, check if they've completed the profile form
            return FutureBuilder<bool>(
              future: _hasCompletedProfileForm(),
              builder: (context, snapshot) {
                if (snapshot.data ?? false) {
                  // User has completed the profile form, navigate to Alumni Dashboard
                  return Alumni_Dashboard();
                } else {
                  // User has not completed the profile form, navigate to Profile Form
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