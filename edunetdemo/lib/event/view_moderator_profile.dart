import 'package:edunetdemo/event/moderator_profile.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewModeratorProfile extends StatefulWidget {
  final String moderatorId;
  const ViewModeratorProfile({super.key, required this.moderatorId});

  @override
  State<ViewModeratorProfile> createState() => _ViewModeratorProfileState();
}

class _ViewModeratorProfileState extends State<ViewModeratorProfile> {
  final FirestoreService _firestoreService = FirestoreService();

  late String moderatorId = '56';
  late String moderatorName = 'john doe';
  late String communityName = 'Mulearn';
  late String about = 'eg';
  late String? linkedIn = 'eg';
  late String? twitter = 'eg';
  late String? mail = 'eg';
  String dpURL = '';

  Map<String, dynamic>? _postData;


  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    moderatorId = widget.moderatorId;
    final postSnapshot = await _firestoreService.getModerator(
      moderatorId: moderatorId,
    );

    Map<String, dynamic>? postData;
    if (postSnapshot.exists) {
      postData = postSnapshot.data() as Map<String, dynamic>;
    } else {
      // Handle the case when the post is not found
      postData = null;
    }

   if (postData != null) {
      moderatorId = widget.moderatorId;
      communityName = postData['communityName'] as String;
      moderatorName = postData['moderatorName'] as String;
      about = postData['about'] as String;
      linkedIn = postData['linkedIn'] as String?;
      twitter = postData['twitter'] as String?;
      mail = postData['mail'] as String?;
      dpURL = postData['dpURL'] as String;
    } else {
      communityName = 'Mulearn';
      about = 'eg';
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
    return Scaffold(
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
                'https://marketplace.canva.com/EAE1oe3H6Sc/1/0/1600w/canva-black-elegant-minimalist-profile-linkedin-banner-nc0eALdRvKU.jpg',
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
                        padding:
                            EdgeInsets.fromLTRB(width * .08, 0, width * .08, 0),
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
                                        communityName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(moderatorName),
                                ],
                              ),
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
                                      value: 'Posts', label: Text('Posts')),
                                ],
                                selected: _selectedButton,
                                onSelectionChanged: updateSelected,
                              ),
                            ),
                            SizedBox(height: width * 0.08),
                              PostsSection.withView(
                                moderatorId: widget.moderatorId,
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
    ));
  }
}
