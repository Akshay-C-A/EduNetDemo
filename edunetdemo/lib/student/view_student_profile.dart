import 'package:edunetdemo/services/firestore.dart';
import 'package:edunetdemo/student/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewStudentProfile extends StatefulWidget {
  final String studentId;
  const ViewStudentProfile({super.key, required this.studentId});

  @override
  State<ViewStudentProfile> createState() => _ViewStudentProfileState();
}

class _ViewStudentProfileState extends State<ViewStudentProfile> {
  final FirestoreService _firestoreService = FirestoreService();

  late String student_name = 'john doe';
  late String student_designation = 'CS Engineer';
  late List<dynamic> skills = ['null'];
  late String studentId;
  late String about = 'eg';
  late String studentDept = 'computer science';
  late String studentYear = '3';
  late String? linkedIn = 'eg';
  late String? twitter = 'eg';
  late String? mail = 'eg';
  late String dpURL = 'eg';

  Map<String, dynamic>? _postData;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    studentId = widget.studentId;
    final postSnapshot = await _firestoreService.getStudent(
      studentId: studentId,
    );

    Map<String, dynamic>? postData;
    if (postSnapshot.exists) {
      postData = postSnapshot.data() as Map<String, dynamic>;
    } else {
      // Handle the case when the post is not found
      postData = null;
    }

    if (postData != null) {
      student_name = postData['studentName'] as String;
      student_designation = postData['studentDesignation'] as String;
      studentId = widget.studentId;
      skills = (postData['skills'] as List<dynamic>).cast<String>();
      about = postData['about'] as String;
      studentDept = postData['studentDept'] as String;
      studentYear = postData['studentYear'] as String;
      linkedIn = postData['linkedIn'] as String;
      twitter = postData['twitter'] as String;
      mail = postData['mail'] as String;
      dpURL = postData['dpURL'] as String;
    } else {
      student_name = 'john doe';
      student_designation = 'CS Engineer';
      skills = ['null'];
      about = 'eg';
      studentDept = 'computer science';
      studentYear = '3';
      linkedIn = 'eg';
      twitter = 'eg';
      mail = 'eg';
      dpURL = 'eg';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account details not found'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Set<String> _selectedButton = {'Details'};

  void updateSelected(Set<String> newSelection) {
    setState(() {
      _selectedButton = newSelection;
    });
  }

  void _copyLink(String iconB) {
    if (iconB == 'LinkedIn') {
      Clipboard.setData(ClipboardData(text: linkedIn.toString()));
    } else if (iconB == 'Twitter') {
      Clipboard.setData(ClipboardData(text: twitter.toString()));
    } else if (iconB == 'Mail') {
      Clipboard.setData(ClipboardData(text: mail.toString()));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Link copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          body: FutureBuilder(
        future: _fetchDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Stack(
              children: [
                Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/edunetdemo-5c098.appspot.com/o/banner%2FSTUDENT.png?alt=media&token=074112ec-e90a-49d5-a782-8fc8d6269028',
                  fit: BoxFit.cover,
                ),
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0, .2],
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: height * .13),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              width * .08, 0, width * .08, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child:
                                        Image.network(dpURL, fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              SizedBox(width: width * .05),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Text(
                                          student_name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(student_designation),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.08),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Department',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    studentDept,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Year',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    studentYear,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              width * .08, width * 0.03, width * .08, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                about,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: width * 0.08),
                              Column(
                                children: [
                                  Text(
                                    'Contact :',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _copyLink('LinkedIn');
                                        },
                                        icon: Image.asset(
                                          'assets/Linkedin.png',
                                          width: 25,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _copyLink('Mail');
                                        },
                                        icon: Image.asset(
                                          'assets/Mail.png',
                                          width: 30,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _copyLink('Twitter');
                                        },
                                        icon: Image.asset(
                                          'assets/X.png',
                                          width: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: width * 0.08),
                              Center(
                                child: SegmentedButton(
                                  segments: <ButtonSegment<String>>[
                                    ButtonSegment(
                                        value: 'Details',
                                        label: Text('Details')),
                                    ButtonSegment(
                                        value: 'Posts', label: Text('Posts')),
                                  ],
                                  selected: _selectedButton,
                                  onSelectionChanged: updateSelected,
                                ),
                              ),
                              SizedBox(height: width * 0.08),
                              if (_selectedButton.contains('Details'))
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SkillsSection(skills: skills),
                                  ],
                                )
                              else
                                PostsSection.withView(
                                  studentId: widget.studentId,
                                  firestoreService: FirestoreService(),
                                  isView: true,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      )),
    );
  }
}
