
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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

      await moderatorsCollection.doc(email).set({
        'ModeratorName': name,
        'ModeratorMail': email,
        'ModeratorId': email,
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



String generatePassword() {
  return 'password123';
}
