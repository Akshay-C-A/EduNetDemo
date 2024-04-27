import 'package:edunetdemo/admin/admin_dashboard.dart';
import 'package:edunetdemo/alumni/alumni_dashboard.dart';
import 'package:edunetdemo/auth/login_page.dart';
import 'package:edunetdemo/alumni/alumni_profile_form.dart';
import 'package:edunetdemo/event/event_dashboard.dart';
import 'package:edunetdemo/student/student_dashboard.dart';
import 'package:edunetdemo/student/student_profile_form.dart';
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
    final edunetModPattern = RegExp(r'\b\w+@moderator\.edunet\.com\b');

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

  //signout
  Future<void> _signOutUser() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }


  bool _isFirstTime = false;
  String? _userType;

   @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userMail = user.email;
      _userType = checkEmailPattern(userMail!);
      if (_userType == 'Student' || _userType == 'Alumni') {
        _isFirstTime = await _firestoreService.isFirstTime(userMail);
      }
    }
    setState(() {}); // Trigger a rebuild after setting the state
  }

  @override
  Widget build(BuildContext context) {
    if (_userType == null) {
      return LoginPage();
    } else if (_userType == 'Student') {
      return _isFirstTime ? const StudentProfileForm() : const Student_Dashboard();
    } else if (_userType == 'Alumni') {
      return _isFirstTime ? const AlumniProfileForm() : const Alumni_Dashboard();
    } else if (_userType == 'Admin') {
      return const AdminDashboard();
    } else if (_userType == 'Moderator') {
      return const EventDashboard();
    } else {
      _signOutUser();
      return LoginPage();
    }
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
