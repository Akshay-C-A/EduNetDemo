import 'package:edunetdemo/admin/admin_dashboard.dart';
import 'package:edunetdemo/alumni/alumni_dashboard.dart';
import 'package:edunetdemo/auth/login_page.dart';
import 'package:edunetdemo/alumni/alumni_profile_form.dart';
import 'package:edunetdemo/event/event_dashboard.dart';
import 'package:edunetdemo/student/student_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirestoreService _firestoreService = FirestoreService();

  String checkEmailPattern(String email) {
    final currentYear = DateTime.now().year;
    // Pattern for emails with @cs.sjcetpalai.ac.in
    final sjcetPattern = RegExp(r'\b\w+@cs\.sjcetpalai\.ac\.in\b');
    // Pattern for emails with @edunet.in
    final edunetAdminPattern = RegExp(r'\b\w+@admin\.edunet\.com\b');
    final edunetModPattern = RegExp(r'\b\w+@mod\.edunet\.com\b');

    if (sjcetPattern.hasMatch(email)) {
      return checkYearPattern(email, currentYear);
    } else if (edunetAdminPattern.hasMatch(email)) {
      return 'Admin';
    } else if (edunetModPattern.hasMatch(email)) {
      return 'Moderator';
    } else {
      return 'null';
    }
  }

  String checkYearPattern(String email, int currentYear) {
    // Pattern for emails with year (e.g. 2025) before @cs.sjcetpalai.ac.in
    final yearPattern = RegExp(r'\b\w+(\d{4})@cs\.sjcetpalai\.ac\.in\b');

    final match = yearPattern.firstMatch(email);
    if (match != null) {
      final emailYear = int.parse(match.group(1)!);
      if (emailYear >= currentYear) {
        return 'Student';
      } else {
        return 'Alumni';
      }
    } else {
      return 'null';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.authStateChanges();
  }

  //signout
  Future<void> _signOutUser() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            // User is logged in, check if their email is in the Firestore database
            final userMail = FirebaseAuth.instance.currentUser!.email;
            String userType = checkEmailPattern(userMail!);

            if (userType == 'Student') {
              return Student_Dashboard();
            } else if (userType == 'Alumni') {
              return FutureBuilder(
                future: _firestoreService.isFirstTime(userMail),
                builder: (context, asnapshot) {
                  if (asnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (asnapshot.hasError) {
                    return Center(
                      child: Text('Error: ${asnapshot.error}'),
                    );
                  } else if (asnapshot.data == true) {
                    return const ProfileForm();
                  } else {
                    return const Alumni_Dashboard();
                  }
                },
              );
            } else if (userType == 'Admin') {
              return AdminDashboard();
            } else if (userType == 'Moderator') {
              return EventDashboard();
            } else {
              _signOutUser();
              return LoginPage();
            }
          } else {
            // User is not logged in, navigate to the LoginPage
            return LoginPage();
          }
        }),
      ),
    );
  }
}







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




// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   _MainPageState createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   final FirestoreService _firestoreService = FirestoreService();
//   late User? currentUser;

//   @override
//   void initState() {
//     super.initState();
//     currentUser = FirebaseAuth.instance.currentUser;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData && snapshot.data != null) {
//             // User is logged in, check if their email is in the Firestore database
//             return FutureBuilder(
//               future: _firestoreService.getAlumniByEmail(snapshot.data!.email!),
//               builder: (context, alumniSnapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                   child: CircularProgressIndicator(),
//                  );
//                 }
//                 else if (alumniSnapshot.hasData && alumniSnapshot.data != null) {
//                   // User's email is in the Firestore database, navigate to the alumni dashboard
//                   return Alumni_Dashboard(
//                     // alumni: alumniSnapshot.data!,
//                   );
//                 }
//                 else {
//                   // User's email is not in the Firestore database, navigate to the profile form
//                   return ProfileForm();
//                 }
//               },
//             );
//           } else {
//             // User is not logged in, navigate to the LoginPage
//             return LoginPage();
//           }
//         },
//       ),
//     );
//   }
// }
