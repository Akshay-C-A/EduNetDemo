import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminManagementPage extends StatefulWidget {
  const AdminManagementPage({Key? key}) : super(key: key);

  @override
  _AdminManagementPageState createState() => _AdminManagementPageState();
}

class _AdminManagementPageState extends State<AdminManagementPage> {
  final moderatorsCollection = FirebaseFirestore.instance.collection('moderators');
  final studentsCollection = FirebaseFirestore.instance.collection('students');
  final alumniCollection = FirebaseFirestore.instance.collection('alumni');

  final TextEditingController _moderatorNameController = TextEditingController();
  final TextEditingController _communityNameController = TextEditingController();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _passoutYearController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _alumniNameController = TextEditingController();

  final _moderatorIconStates = <String, bool>{};

  @override
  void dispose() {
    _moderatorNameController.dispose();
    _communityNameController.dispose();
    _studentNameController.dispose();
    _passoutYearController.dispose();
    _departmentController.dispose();
    _alumniNameController.dispose();
    super.dispose();
  }

  Future<void> _addModerator(String name, String communityName) async {
    final email = '${name.toLowerCase()}-${communityName.toLowerCase()}@moderator.edunet.com';
    final password = generatePassword();
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
        'isSuspended': false,
      });

      // Update icon state for the new moderator
      setState(() {
        _moderatorIconStates[email] = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Moderator added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding moderator: $e')),
      );
    }
  }

  Future<void> _toggleModeratorSuspension(String docId, bool isSuspended) async {
    try {
      await moderatorsCollection.doc(docId).update({'isSuspended': isSuspended});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Moderator ${isSuspended ? 'suspended' : 'unsuspended'} successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ${isSuspended ? 'suspending' : 'unsuspending'} moderator: $e')),
      );
    }
  }

  void _toggleModeratorIcon(String docId) {
    setState(() {
      _moderatorIconStates[docId] = !_moderatorIconStates[docId]!;
    });
  }

  Widget _buildModeratorList() {
    return Column(
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
                  final docId = moderatorDoc.id;
                  final name = moderatorDoc['moderatorName'];
                  final email = moderatorDoc['moderatorMail'];
                  final communityName = moderatorDoc['communityName'];
                  final isSuspended = moderatorDoc['isSuspended'];

                  _moderatorIconStates.putIfAbsent(docId, () => isSuspended);

                  return ListTile(
                    title: Text(name),
                    subtitle: Text('$email ($communityName)'),
                    trailing: _moderatorIconStates[docId]! ? IconButton(
                      icon: Icon(Icons.person_add),
                      onPressed: () {
                        _toggleModeratorIcon(docId);
                        _toggleModeratorSuspension(docId, false);
                      },
                    ) : IconButton(
                      icon: Icon(Icons.person_remove),
                      onPressed: () {
                        _toggleModeratorIcon(docId);
                        _toggleModeratorSuspension(docId, true);
                      },
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
                  decoration: InputDecoration(hintText: 'Moderator name'),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  controller: _communityNameController,
                  decoration: InputDecoration(hintText: 'Community name'),
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
    );
  }

  Future<void> _addStudent(String name, String passoutYear, String dept) async {
    final email = '${name.toLowerCase()}${passoutYear}@${dept.toLowerCase()}.sjcetpalai.ac.in';
    final password = generatePassword();
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await studentsCollection.doc(email).set({
        'studentName': name,
        'studentEmail': email,
        'studentId': email,
        'passoutYear': passoutYear,
        'department': dept,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding student: $e')),
      );
    }
  }

  Widget _buildStudentList() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: studentsCollection.snapshots(),
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
                  final studentDoc = snapshot.data!.docs[index];
                  final name = studentDoc['studentName'];
                  final email = studentDoc['studentEmail'];
                  final passoutYear = studentDoc['passoutYear'];
                  final department = studentDoc['department'];

                  return ListTile(
                    title: Text(name),
                    subtitle: Text('$email ($passoutYear, $department)'),
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
                  controller: _studentNameController,
                  decoration: InputDecoration(hintText: 'Student name'),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  controller: _passoutYearController,
                  decoration: InputDecoration(hintText: 'Passout year'),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  controller: _departmentController,
                  decoration: InputDecoration(hintText: 'Department'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  final name = _studentNameController.text;
                  final passoutYear = _passoutYearController.text;
                  final department = _departmentController.text;
                  if (name.isNotEmpty && passoutYear.isNotEmpty && department.isNotEmpty) {
                    _addStudent(name, passoutYear, department);
                    _studentNameController.clear();
                    _passoutYearController.clear();
                    _departmentController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _addAlumni(String name, String passoutYear, String dept) async {
    final email = '${name.toLowerCase()}${passoutYear}@${dept.toLowerCase()}.sjcetpalai.ac.in';
    final password = generatePassword();
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await alumniCollection.doc(email).set({
        'alumniName': name,
        'alumniEmail': email,
        'alumniId': email,
        'passoutYear': passoutYear,
        'department': dept,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alumni added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding alumni: $e')),
      );
    }
  }

  Widget _buildAlumniList() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: alumniCollection.snapshots(),
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
                  final alumniDoc = snapshot.data!.docs[index];
                  final name = alumniDoc['alumniName'];
                  final email = alumniDoc['alumniEmail'];
                  final passoutYear = alumniDoc['passoutYear'];
                  final department = alumniDoc['department'];

                  return ListTile(
                    title: Text(name),
                    subtitle: Text('$email ($passoutYear, $department)'),
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
                  controller: _alumniNameController,
                  decoration: InputDecoration(hintText: 'Alumni name'),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  controller: _passoutYearController,
                  decoration: InputDecoration(hintText: 'Passout year'),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  controller: _departmentController,
                  decoration: InputDecoration(hintText: 'Department'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  final name = _alumniNameController.text;
                  final passoutYear = _passoutYearController.text;
                  final department = _departmentController.text;
                  if (name.isNotEmpty && passoutYear.isNotEmpty && department.isNotEmpty) {
                    _addAlumni(name, passoutYear, department);
                    _alumniNameController.clear();
                    _passoutYearController.clear();
                    _departmentController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // title: Text('Admin Management'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Moderators'),
              Tab(text: 'Students'),
              Tab(text: 'Alumni'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildModeratorList(),
            _buildStudentList(),
            _buildAlumniList(),
          ],
        ),
      ),
    );
  }
}

String generatePassword() {
  return 'password123';
}
