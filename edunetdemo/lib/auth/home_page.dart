// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final user = FirebaseAuth.instance.currentUser!;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Signed In as : ${user.email!}',
//               style: TextStyle(fontSize: 20.0),
//             ),
//             SizedBox(
//               height: 30.0,
//             ),
//             MaterialButton(
//               onPressed: () {
//                 FirebaseAuth.instance.signOut();
//               },
//               color: Colors.blueAccent,
//               child: Text('Sign Out'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
