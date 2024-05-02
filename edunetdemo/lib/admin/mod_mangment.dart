import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ModeratorManagementPage extends StatefulWidget {
  const ModeratorManagementPage({Key? key}) : super(key: key);

  @override
  _ModeratorManagementPageState createState() => _ModeratorManagementPageState();
}

class _ModeratorManagementPageState extends State<ModeratorManagementPage> {
  final moderatorsCollection = FirebaseFirestore.instance.collection('moderators');

  Future<void> _addModerator(String name, String communityName) async {
    final email = '${name.toLowerCase()}-${communityName.toLowerCase()}@moderator.edunet.com';
    final password = generatePassword(); // Implement password generation logic

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await moderatorsCollection.doc(email).set({
        'moderatorName': name,
        'moderatorMail': email,
        'moderatorId': email,
        'communityName': communityName,
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

  Future<void> _deleteModerator(String docId) async {
    try {
      final moderatorDoc = await moderatorsCollection.doc(docId).get();
      final email = moderatorDoc.data()?['moderatorMail'] as String;

      final signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
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
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    final name = moderatorDoc['moderatorName'];
                    final email = moderatorDoc['moderatorMail'];
                    final communityName = moderatorDoc['communityName'];

                    return ListTile(
                      title: Text(name),
                      subtitle: Text('$email ($communityName)'),
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _moderatorNameController,
                    decoration: InputDecoration(
                      hintText: 'Moderator name',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: _communityNameController,
                    decoration: InputDecoration(
                      hintText: 'Community name',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    final name = _moderatorNameController.text;
                    final communityName = _communityNameController.text;
                    if (name.isNotEmpty && communityName.isNotEmpty) {
                      _addModerator(name, communityName);
                      _moderatorNameController.clear();
                      _communityNameController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final _moderatorNameController = TextEditingController();
  final _communityNameController = TextEditingController();

  @override
  void dispose() {
    _moderatorNameController.dispose();
    _communityNameController.dispose();
    super.dispose();
  }
}

String generatePassword() {
  return 'password123';
}