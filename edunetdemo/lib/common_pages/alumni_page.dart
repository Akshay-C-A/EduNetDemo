import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/alumni/alumni_post_card.dart';
import 'package:edunetdemo/alumni/alumni_profile.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:flutter/material.dart';

class AlumniPage extends StatefulWidget {
  const AlumniPage({super.key});

  @override
  State<AlumniPage> createState() => _AlumniPageState();
}

class _AlumniPageState extends State<AlumniPage> {
  final FirestoreService AlumniFirestoreService = FirestoreService();

  final TextEditingController textController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alumni Posts'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                          alumni: Alumni(
                              alumni_name: 'Sura Surendran',
                              alumni_designation: 'CS Engineer',
                              skills: ['Flutter', 'Django', 'C', 'C++'],
                              email: 'sura@gmail.com',
                              company: 'WIPRO',
                              alumni_dept: 'CS'))));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                //backgroundImage: NetworkImage('https://example.com/profile.jpg'),
                radius: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: AlumniFirestoreService.getAlumniPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          List alumniPostList = snapshot.data!.docs;
          return ListView.builder(
            itemCount: alumniPostList.length,
            itemBuilder: (context, index) {
              // Get each individual doc
              DocumentSnapshot document = alumniPostList[index];
              // String docID = document.id;

              // Get note from each doc
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String type = data['type'];
              String alumniName = data['alumniName'];
              String alumniDesignation = data['alumniDesignation'];
              String caption = data['caption'];
              String description = data['description'];
              String? imageURL = data['imageURL'];

              // Display as a list title
              return AlumniPostCard(
                  type: type,
                  alumniName: alumniName,
                  alumniDesignation: alumniDesignation,
                  caption: caption,
                  description: description,
                  imageURL: imageURL ?? '');

              // return Card(
              //   elevation: 2,
              //   margin: EdgeInsets.all(8),
              //   child: ListTile(
              //     title: Text(noteText),
              //     onTap: () {},
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}
