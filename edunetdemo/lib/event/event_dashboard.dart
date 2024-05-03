import 'package:edunetdemo/auth/login_check2.dart';
import 'package:edunetdemo/common_pages/event_page.dart';
import 'package:edunetdemo/common_pages/event_search.dart';
import 'package:edunetdemo/event/event_newpost.dart';
import 'package:edunetdemo/event/event_notification.dart';
import 'package:edunetdemo/event/event_posted.dart';
import 'package:edunetdemo/event/moderator_profile.dart';
import 'package:edunetdemo/services/email_service.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> _signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // Navigate to the sign-in screen or any other desired screen after sign-out
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
      (route) => false,
    );
  } catch (e) {
    print('Error signing out: $e');
  }
}

class EventDashboard extends StatefulWidget {
  const EventDashboard({super.key});

  @override
  State<EventDashboard> createState() => _EventDashboardState();
}

class _EventDashboardState extends State<EventDashboard> {
  final FirestoreService _firestoreService = FirestoreService();
  final currentUser = FirebaseAuth.instance.currentUser;

  late String moderatorId = '56';
  late String moderatorName = 'john doe';
  late String communityName = 'Mulearn';
  String about = 'Edit profile to change ABout';
  String? linkedIn = 'None';
  String? twitter = 'None';
  String? mail = 'None';
  String dpURL = '';

  Map<String, dynamic>? _postData;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  int _selectedIndex = 0;

  Future<void> _fetchDetails() async {
    moderatorId = currentUser!.email!;
    final postSnapshot = await _firestoreService.getModerator(
      moderatorId: moderatorId.toString(),
    );

    Map<String, dynamic>? postData;
    if (postSnapshot.exists) {
      postData = postSnapshot.data() as Map<String, dynamic>;
    } else {
      // Handle the case when the post is not found
      postData = null;
    }

    if (postData != null) {
      moderatorId = currentUser!.email!;
      communityName = postData['communityName'] as String;
      moderatorName = postData['moderatorName'] as String;
      postData['about'] == ''
          ? about = about = 'Edit Profile to Add About'
          : about = postData['about'] as String;
      postData['linkedIn'] == ''
          ? linkedIn = 'None'
          : linkedIn = postData['linkedIn'] as String;
      postData['twitter'] == ''
          ? twitter = 'None'
          : twitter = postData['twitter'] as String;
      postData['mail'] == ''
          ? mail = 'None'
          : mail = postData['mail'] as String;
      postData['dpURL'] == ''
          ? dpURL = 'None'
          : dpURL = postData['dpURL'] as String;
    } else {
      communityName = 'Mulearn';
      about = 'Edit Profile to Update About';
      linkedIn = 'None';
      twitter = 'None';
      mail = 'None';
      dpURL = '';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account details not found'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      EventPage(),
      EventNewPostPage(
        moderator: Moderator(
          linkedIn: linkedIn,
          twitter: twitter,
          mail: mail,
          dpURL: dpURL,
          moderatorId: moderatorId,
          communityName: communityName,
          moderatorName: moderatorName,
          about: about,
        ),
      ),
      EventNotificationPage(),
      PostedEvents(
        moderatorId: moderatorId,
        communityName: communityName,
      ),
    ];
    return FutureBuilder(
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
          return Scaffold(
            appBar: AppBar(
              title: Text('Moderator'),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventSearchPage()));
                    },
                    icon: Icon(Icons.search)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModeratorProfileScreen(
                              moderator: Moderator(
                            linkedIn: linkedIn,
                            twitter: twitter,
                            mail: mail,
                            dpURL: dpURL,
                            moderatorId: moderatorId,
                            communityName: communityName,
                            moderatorName: moderatorName,
                            about: about,
                          )),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(dpURL),
                      radius: 20.0,
                    ),
                  ),
                ),
              ],
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Events',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Post',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Notification',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.alarm),
                  label: 'Event Posted',
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
