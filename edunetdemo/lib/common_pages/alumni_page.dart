import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/alumni/alumni_dashboard.dart';
import 'package:edunetdemo/alumni/alumni_post_card.dart';
import 'package:edunetdemo/alumni/alumni_profile.dart';
import 'package:edunetdemo/alumni/alumni_profile_old.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:flutter/material.dart';

class AlumniPage extends StatefulWidget {
  final Alumni alumni;
  // const AlumniPage({super.key});
  const AlumniPage({super.key, required this.alumni});

  @override
  State<AlumniPage> createState() => _AlumniPageState();
}

class _AlumniPageState extends State<AlumniPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  final FirestoreService firestoreService = FirestoreService();

  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getAlumniPostsStream(),
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
              String alumniId = data['alumniId'];
              String alumniName = data['alumniName'];
              String alumniDesignation = data['alumniDesignation'];
              String caption = data['caption'];
              String description = data['description'];
              String? imgURL = data['imageURL'];

              // Display as a list title
              return AlumniPostCard(
                type: type,
                alumnId: alumniId,
                alumniName: alumniName,
                alumniDesignation: alumniDesignation,
                caption: caption,
                description: description,
                imageURL: imgURL ?? '',
                postId: document.id,
                likes: List<String>.from(data['likes'] ?? []),
              );
            },
          );
        },
      ),
    );
  }
}
