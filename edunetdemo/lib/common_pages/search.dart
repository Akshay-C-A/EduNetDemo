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
