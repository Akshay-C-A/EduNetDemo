
// // src/screens/auth_screen.dart
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:edunetdemo/try/home_screen.dart';

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   Future<void> _signIn() async {
//     try {
//       final email = _emailController.text.trim();
//       final password = _passwordController.text.trim();

//       if (email.isNotEmpty && password.isNotEmpty) {
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//         // Navigator.pushReplacement(
//         //   context,
//         //   MaterialPageRoute(builder: (context) => const HomeScreen()),
//         // );
//       }
//     } catch (e) {
//       print('Error signing in: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('EduNet'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(
//                 labelText: 'Password',
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 32.0),
//             ElevatedButton(
//               onPressed: _signIn,
//               child: const Text('Sign In'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }