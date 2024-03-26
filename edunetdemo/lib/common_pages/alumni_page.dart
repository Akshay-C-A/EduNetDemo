import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/services/firestore.dart';

import 'package:flutter/material.dart';

class AlumniPage extends StatefulWidget {
  const AlumniPage({super.key});

  @override
  State<AlumniPage> createState() => _AlumniPageState();
}

class _AlumniPageState extends State<AlumniPage> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController textController = TextEditingController();

  //open a dialogue box to add a note
  void openNoteBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    //add a note
                    firestoreService.addTitle(textController.text);

                    //clear text controller
                    textController.clear();

                    //close the box
                    Navigator.pop(context);
                  },
                  child: Text("Add"),
                )
              ],
            ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alumni Posts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getInternshipOffersStream(),
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
              String noteText = data['title'];

              // Display as a list title
              return Card(
                elevation: 2,
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(noteText),
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
    );
  }
}
