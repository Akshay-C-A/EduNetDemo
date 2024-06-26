// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   bool _isLoading = false;
//   bool _isObscure = true;
//   String? _emailError;
//   String? _passwordError;

//   Future<UserCredential> signInWithGoogle() async {
//   // Trigger the authentication flow
//   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//   // Obtain the auth details from the request
//   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

//   // Create a new credential
//   final credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth?.accessToken,
//     idToken: googleAuth?.idToken,
//   );

//   // Once signed in, return the UserCredential
//   return await FirebaseAuth.instance.signInWithCredential(credential);
// }

//   Future<void> signIn() async {
//     setState(() {
//       _isLoading = true;
//       _emailError = null;
//       _passwordError = null;
//     });

//     try {
//       // Validate email and password
//       if (emailController.text.trim().isEmpty) {
//         setState(() {
//           _emailError = 'Email is required';
//         });
//         return;
//       }
//       if (passwordController.text.trim().isEmpty) {
//         setState(() {
//           _passwordError = 'Password is required';
//         });
//         return;
//       }

//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         if (e.code == 'invalid-email') {
//           _emailError = 'Invalid email address';
//         } else if (e.code == 'wrong-password') {
//           _passwordError = 'Incorrect password';
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Error signing in: ${e.message}'),
//             ),
//           );
//         }
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.0),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 Text(
//                   'LOGIN',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 45.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 10.0),
//                 TextField(
//                   controller: emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Email id',
//                     errorText: _emailError,
//                     errorStyle: TextStyle(color: Colors.red),
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
//                 TextField(
//                   controller: passwordController,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     errorText: _passwordError,
//                     errorStyle: TextStyle(color: Colors.red),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isObscure ? Icons.visibility : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isObscure = !_isObscure;
//                         });
//                       },
//                     ),
//                   ),
//                   obscureText: _isObscure,
//                 ),
//                 SizedBox(height: 20.0),
//                 if (_isLoading)
//                   CircularProgressIndicator()
//                 else
//                   ElevatedButton(
//                     onPressed: () {
//                       signIn();
//                     },
//                     child: Text('Login'),
//                   ),
//                   SizedBox(height: 20.0),
//                   Center(child: Text("or")),
//                   SizedBox(height: 20.0),
//                   ElevatedButton(
//                     onPressed: () async {
//                   try {
//                     await signInWithGoogle();
//                     // Handle successful sign-in
//                   } catch (e) {
//                     // Handle sign-in error
//                   }
//                 },
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                               Image.asset('assets/google.png', height: 24.0),
//                               SizedBox(width: 16.0),
//                               Text(
//                                 'Sign in with Google',
//                                 style: TextStyle(
//                                   fontSize: 16.0,
//                                   // fontWeight: FontWeight.w400,
//                                 )
//                               ),
//                     ],
//                   ),
//               ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:edunetdemo/admin/admin_dashboard.dart';
import 'package:edunetdemo/alumni/alumni_dashboard.dart';
import 'package:edunetdemo/auth/login_check2.dart';
import 'package:edunetdemo/event/event_dashboard.dart';
import 'package:edunetdemo/student/student_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscure = true;
  String? _emailError;
  String? _passwordError;

  // Future<UserCredential> signInWithGoogle() async {
  //   // Sign out the previously authenticated Google account
  //   await _googleSignIn.signOut();

  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;

  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }
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

  void _navigateToPage(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userMail = user.email;
    final userType = checkEmailPattern(userMail!);

    if (userType == 'Student') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Student_Dashboard()),
      );
    } else if (userType == 'Alumni') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Alumni_Dashboard()),
      );
    } else if (userType == 'Admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard()),
      );
    } else if (userType == 'Moderator') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EventDashboard()),
      );
    } else {
      // Handle other user types or invalid emails
    }
  }
}

  Future<void> signInWithGoogle() async {
  try {
    // Sign out the previously authenticated Google account
    await _googleSignIn.signOut();

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    // Navigate to the appropriate page after successful sign-in
    _navigateToPage(context);
  } catch (e) {
    // Handle sign-in error
    print('Error signing in with Google: $e');
  }
}

  Future<void> signIn() async {
    setState(() {
      _isLoading = true;
      _emailError = null;
      _passwordError = null;
    });

    try {
      // Validate email and password
      if (emailController.text.trim().isEmpty) {
        setState(() {
          _emailError = 'Email is required';
        });
        return;
      }
      if (passwordController.text.trim().isEmpty) {
        setState(() {
          _passwordError = 'Password is required';
        });
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'invalid-email') {
          _emailError = 'Invalid email address';
        } else if (e.code == 'wrong-password') {
          _passwordError = 'Incorrect password';
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error signing in: ${e.message}'),
            ),
          );
        }
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'LOGIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email id',
                    errorText: _emailError,
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: _passwordError,
                    errorStyle: TextStyle(color: Colors.red),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  obscureText: _isObscure,
                ),
                SizedBox(height: 20.0),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: signIn,
                    child: Text('Login'),
                  ),
                SizedBox(height: 20.0),
                Center(child: Text("or")),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: signInWithGoogle,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/google.png', height: 24.0),
                      SizedBox(width: 16.0),
                      Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
