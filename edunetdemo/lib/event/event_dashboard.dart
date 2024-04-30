import 'package:edunetdemo/auth/login_check2.dart';
import 'package:edunetdemo/common_pages/event_page.dart';
import 'package:edunetdemo/event/event_newpost.dart';
import 'package:edunetdemo/event/event_notification.dart';
import 'package:edunetdemo/event/event_posted.dart';
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
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    EventPage(),
    EventNewPostPage(),
    EventNotificationPage(),
    ProfilePage(),
    PostedEvents(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              title: Text('Alumni'),
              actions: [
                // IconButton(
                //     onPressed: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => UserSearchPage()));
                //     },
                //     icon: Icon(Icons.search)),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => ProfileScreen(
                    //           alumni: Alumni(
                    //         alumni_name: alumni_name,
                    //         alumniId: alumniId,
                    //         alumni_designation: alumni_designation,
                    //         skills: skills,
                    //         about: about,
                    //         company: company,
                    //         linkedIn: linkedIn,
                    //         twitter: twitter,
                    //         mail: mail,
                    //         dpURL: dpURL,
                    //       )),
                    //     ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                      // backgroundImage: NetworkImage(dpURL),
                      radius: 20.0,
                    ),
                  ),
                ),
              ],
            ),
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Event Posted',
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () => _signOut(context),
            ),
          ],
        ),
      ),
    );
  }
}
