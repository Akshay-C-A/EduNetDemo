import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/alumni/view_alumni_profile.dart';
import 'package:edunetdemo/student/view_student_profile.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = '';
  List<Map<String, dynamic>> data = [
    {
      'name': 'John',
      'image':
          'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      'email': 'john@gmail.com'
    },
    {
      'name': 'Eric',
      'image':
          'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      'email': 'eric@gmail.com'
    },
    {
      'name': 'Mark',
      'image':
          'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      'email': 'mark@gmail.com'
    },
    {
      'name': 'Ela',
      'image':
          'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      'email': 'ela@gmail.com'
    },
    {
      'name': 'Sue',
      'image':
          'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      'email': 'sue@gmail.com'
    },
    {
      'name': 'Lothe',
      'image':
          'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      'email': 'lothe@gmail.com'
    },
    {
      'name': 'Alyssa',
      'image':
          'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      'email': 'Alyssa@gmail.com'
    },
    {
      'name': 'Nichols',
      'image':
          'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      'email': 'Nichols@gmail.com'
    },
    {
      'name': 'Welch',
      'image':
          'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      'email': 'Welch@gmail.com'
    },
    {
      'name': 'Delacruz',
      'image':
          'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      'email': 'Delacruz@gmail.com'
    },
    {
      'name': 'Tania',
      'image':
          'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      'email': 'Tania@gmail.com'
    },
    {
      'name': 'Jeanie',
      'image':
          'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
      'email': 'Jeanie@gmail.com'
    }
  ];

  addData() async {
    for (var element in data) {
      FirebaseFirestore.instance.collection('user').add(element);
    }
    print('All data added');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // addData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('user').snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshots.hasData || snapshots.data == null) {
            return Center(
              child: Text('No data found'),
            );
          }

          return ListView.builder(
            itemCount: snapshots.data!.docs.length,
            itemBuilder: (context, index) {
              var data =
                  snapshots.data!.docs[index].data() as Map<String, dynamic>?;

              if (data == null) {
                return SizedBox.shrink();
              }

              bool isAlumni = false;
              if (data['studentId'] == null) {
                isAlumni = true;
              }

              String userName = data['studentId'] ?? data['alumniId'];

              if (name.isEmpty) {
                return GestureDetector(
                  onTap: () {
                    if (data['studentId'] == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewAlumniProfile(
                                  alumniId: data['alumniId'])));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewStudentProfile(
                                  studentId: data['studentId'])));
                    }
                  },
                  child: ListTile(
                    title: Text(
                      isAlumni
                          ? "${data['alumniName']} • ALUMNI"
                          : "${data['studentName']} • STUDENT",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      data['studentDesignation'] ?? data['alumniDesignation'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data['dpURL']),
                    ),
                  ),
                );
              }

              if (data['studentName']
                      .toString()
                      .toLowerCase()
                      .startsWith(name.toLowerCase()) ||
                  data['alumniName']
                      .toString()
                      .toLowerCase()
                      .startsWith(name.toLowerCase())) {
                return GestureDetector(
                  onTap: () {
                    if (data['studentId'] == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewAlumniProfile(
                                  alumniId: data['alumniId'])));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewStudentProfile(
                                  studentId: data['studentId'])));
                    }
                  },
                  child: ListTile(
                    title: Text(
                      isAlumni
                          ? "${data['alumniName']} • ALUMNI"
                          : "${data['studentName']} • STUDENT",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      data['studentDesignation'] ?? data['alumniDesignation'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data['dpURL']),
                    ),
                  ),
                );
              }

              return Container();
            },
          );
        },
      ),
    );
  }
}
