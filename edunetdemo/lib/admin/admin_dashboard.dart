// import 'package:edunetdemo/common_pages/event_page.dart';
// import 'package:edunetdemo/common_pages/search.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});

//   @override
//   State<AdminDashboard> createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   final currentUser = FirebaseAuth.instance.currentUser;
//   int _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> widgetOptions = <Widget>[
//       EventPage(), // Add additional pages or widgets here
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Dashboard'),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => SearchPage()));
//               },
//               icon: Icon(Icons.search)),
//           IconButton(
//             onPressed: () {
//               FirebaseAuth.instance.signOut();
//             },
//             icon: Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: widgetOptions,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Events',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'Manage Moderators',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:edunetdemo/auth/login_check2.dart';
import 'package:edunetdemo/common_pages/alumni_page.dart';
import 'package:edunetdemo/common_pages/event_page.dart';
import 'package:edunetdemo/common_pages/user_search.dart';
import 'package:edunetdemo/common_pages/student_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final currentUser = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      EventPage(),
      StudentPage(),
      AlumniPage(),
      ModeratorManagementPage(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserSearchPage()),
              );
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Student',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Alumni',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Moderators',
          ),
        ],
      ),
    );
  }
}

class ModeratorManagementPage extends StatefulWidget {
  const ModeratorManagementPage({Key? key}) : super(key: key);

  @override
  _ModeratorManagementPageState createState() =>
      _ModeratorManagementPageState();
}

class _ModeratorManagementPageState extends State<ModeratorManagementPage> {
  final moderatorsCollection =
      FirebaseFirestore.instance.collection('moderators');

  Future<void> _addModerator(String name) async {
    final email = '${name.toLowerCase()}@moderator.edunet.com';
    final password = generatePassword(); // Implement password generation logic

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await moderatorsCollection.doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Moderator added successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding moderator: $e'),
        ),
      );
    }
  }

  // Future<void> _deleteModerator(String docId) async {
  //   try {
  //     final moderatorDoc = await moderatorsCollection.doc(docId).get();
  //     final email = moderatorDoc.data()?['email'] as String;

  //     final userRecord = await FirebaseAuth.instance.getUserByEmail(email);
  //     if (userRecord != null) {
  //       await FirebaseAuth.instance.deleteUser(userRecord.user!.uid);
  //     }

  //     await moderatorsCollection.doc(docId).delete();

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Moderator deleted successfully'),
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error deleting moderator: $e'),
  //       ),
  //     );
  //   }
  // }

  Future<void> _deleteModerator(String docId) async {
    try {
      final moderatorDoc = await moderatorsCollection.doc(docId).get();
      final email = moderatorDoc.data()?['email'] as String;

      // final signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      final signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        final user = await FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.delete();
        }
      }

      await moderatorsCollection.doc(docId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Moderator deleted successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting moderator: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: moderatorsCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final moderatorDoc = snapshot.data!.docs[index];
                    final name = moderatorDoc['name'];
                    final email = moderatorDoc['email'];

                    return ListTile(
                      title: Text(name),
                      subtitle: Text(email),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteModerator(moderatorDoc.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _moderatorNameController,
              decoration: InputDecoration(
                hintText: 'Enter moderator name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    final name = _moderatorNameController.text;
                    if (name.isNotEmpty) {
                      _addModerator(name);
                      _moderatorNameController.clear();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final _moderatorNameController = TextEditingController();

  @override
  void dispose() {
    _moderatorNameController.dispose();
    super.dispose();
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Page'),
    );
  }
}

String generatePassword() {
  // Implement password generation logic here
  // This could involve generating a random string of characters with a certain length and complexity
  // For simplicity, let's return a dummy password
  return 'password123';
}
