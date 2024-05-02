import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EventParticipation extends StatefulWidget {
  final String moderatorId;
  final String postId;
  final String eventTitle;
  final String communityName;

  const EventParticipation(
      {super.key,
      required this.postId,
      required this.moderatorId,
      required this.eventTitle,
      required this.communityName});

  @override
  State<EventParticipation> createState() => _EventParticipationState();
}

class _EventParticipationState extends State<EventParticipation> {
  FirestoreService firestoreService = FirestoreService();
  bool _verifyLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Column(
        children: [
          Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getEventParticipantsStream(
                    moderatorId: widget.moderatorId, postId: widget.postId),
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

                  List eventParticipantList = snapshot.data!.docs;
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Total no. of participants: ${eventParticipantList.length}'),
                        SizedBox(height: 10),
                        // Text(
                        //     'No. of Enrolled students: ${enrolledStudents.length}'),
                      ]);
                }),
          ),
          SizedBox(height: 20),
          Text(
            'Participants',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getEventParticipantsStream(
                  moderatorId: widget.moderatorId, postId: widget.postId),
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

                List eventPostList = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: eventPostList.length,
                  itemBuilder: (context, index) {
                    // Get each individual doc
                    DocumentSnapshot document = eventPostList[index];
                    // String docID = document.id;
                    // Get note from each doc
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    // String studentName = data['moderatorId'];

                    String studentName = data['studentName'];
                    String department = data['department'];
                    String batch = data['batch'];
                    bool isVerified = data['isVerified'] ?? false;
                    String studentId = data['studentId'];
                    String studentEmail = data['studentMail'];
                    // Display as a list title

                    return Card(
                      child: ListTile(
                        leading: Text('${index + 1}'),
                        title: Text(studentName),
                        subtitle: Text('$department batch'),
                        trailing: isVerified
                            ? Text(
                                'Verified',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 15),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _verifyLoading = true;
                                  });
                                  firestoreService.verifyStudent(
                                      studentId: studentId,
                                      postId: widget.postId,
                                      studentName: studentName,
                                      studentEmail: studentEmail,
                                      eventTitle: widget.eventTitle,
                                      communityMail: 'communityMail',
                                      communityName: widget.communityName,
                                      moderatorId: widget.moderatorId);
                                  setState(() {
                                    _verifyLoading = false;
                                  });
                                },
                                child: _verifyLoading
                                    ? SizedBox(
                                        width:
                                            24.0, // Adjust the width and height as per your requirements
                                        height: 24.0,
                                        child: CircularProgressIndicator(
                                          color: Colors.green,
                                          // strokeWidth:
                                          //     3.0, // Increase or decrease this value to adjust the circle's thickness
                                        ),
                                      )
                                    : Text('Verify')),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Column(
      //   children: [
      //     StreamBuilder<QuerySnapshot>(
      //         stream: firestoreService.getEventParticipantsStream(
      //             postId: widget.postId),
      //         builder: (context, snapshot) {
      //           if (snapshot.hasError) {
      //             return Text('Error: ${snapshot.error}');
      //           }

      //           if (snapshot.connectionState == ConnectionState.waiting) {
      //             return Center(child: CircularProgressIndicator());
      //           }

      //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      //             return Center(child: Text('No data available'));
      //           }

      //           List eventParticipantList = snapshot.data!.docs;
      //           return Padding(
      //               padding: EdgeInsets.all(8),
      //               child: Center(
      //                   child: Column(
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       children: [
      //                     Align(
      //                       alignment: Alignment.centerLeft,
      //                       child: Text(
      //                           'Total no. of participants: ${enrolledStudents.length}'),
      //                     ),
      //                     SizedBox(height: 10),
      //                     Align(
      //                       alignment: Alignment.centerLeft,
      //                       child: Text(
      //                           'No. of Enrolled students: ${enrolledStudents.length}'),
      //                     ),
      //                     SizedBox(height: 20),
      //                   ])));
      //         }),
      //     SizedBox(height: 20),
      //     Text(
      //       'Participants ///',
      //       style: TextStyle(
      //         fontWeight: FontWeight.bold,
      //         fontSize: 18,
      //       ),
      //     ),
      //     SizedBox(height: 10),
      //     StreamBuilder<QuerySnapshot>(
      //       stream: firestoreService.getEventParticipantsStream(
      //           postId: widget.postId),
      //       builder: (context, snapshot) {
      //         if (snapshot.hasError) {
      //           return Text('Error: ${snapshot.error}');
      //         }

      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return Center(child: CircularProgressIndicator());
      //         }

      //         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      //           return Center(child: Text('No data available'));
      //         }

      //         List eventPostList = snapshot.data!.docs;
      //         return ListView.builder(
      //           itemCount: eventPostList.length,
      //           itemBuilder: (context, index) {
      //             // Get each individual doc
      //             DocumentSnapshot document = eventPostList[index];
      //             // String docID = document.id;
      //             // Get note from each doc
      //             Map<String, dynamic> data =
      //                 document.data() as Map<String, dynamic>;

      //             // Display as a list title
      //             return ListTile(
      //               title: Text(data['studentName']),
      //               subtitle:
      //                   Text('Age: ${data['department']}${data['batch']}'),
      //             );
      //           },
      //         );
      //       },
      //     ),
      //   ],
      // ),

      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Align(
      //         alignment: Alignment.centerLeft,
      //         child: Text('Total no. of participants: ${enrolledStudents.length}'),
      //       ),
      //       SizedBox(height: 10),
      //       Align(
      //         alignment: Alignment.centerLeft,
      //         child: Text('No. of Enrolled students: ${enrolledStudents.length}'),
      //       ),
      //       SizedBox(height: 20),
      //       Text(
      //         'Participants',
      //         style: TextStyle(
      //           fontWeight: FontWeight.bold,
      //           fontSize: 18,
      //         ),
      //       ),
      //       SizedBox(height: 10),
      //       Expanded(
      //         child: ListView.builder(
      //           itemCount: enrolledStudents.length,
      //           itemBuilder: (context, index) {
      //             final student = enrolledStudents[index];
      //             return ListTile(
      //               title: Text(student.name),
      //               subtitle: Text('Age: ${student.age}, Email: ${student.email}'),
      //             );
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
