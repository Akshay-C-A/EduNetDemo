
import 'package:edunetdemo/common_pages/event_page.dart';
import 'package:edunetdemo/event/event_newpost.dart';
import 'package:edunetdemo/event/event_notification.dart';
import 'package:flutter/material.dart';

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
    EventNotificationPage()
  ];
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      // appBar: AppBar(
      //   title: Text('Bottom Navigation Bar Example'),
      // ),
      body: Center(
        child: IndexedStack(index: _selectedIndex,children: _widgetOptions,),
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
        ],
      ),
    );
  }
}







