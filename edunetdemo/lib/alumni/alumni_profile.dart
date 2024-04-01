import 'package:flutter/material.dart';

class Alumni {
  final String alumni_name;
  final String alumni_designation;
  final List<String> skills;
  final String email;
  final String company;
  final String alumni_dept;

  Alumni({
    required this.alumni_name,
    required this.alumni_designation,
    required this.skills,
    required this.email,
    required this.company,
    required this.alumni_dept,
  });
}

class ProfilePage extends StatefulWidget {
  Alumni alumni;

  ProfilePage({required this.alumni});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Color color2566be = Color(0xFF2566BE);

    LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color2566be.withOpacity(0.5), // Lighter shade
        color2566be, // Original color
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alumni.alumni_name),
        // Set title to alumni's name
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: gradient,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(
                        'assets/profile_photo.jpg'), // Add profile photo asset path or URL
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.alumni.alumni_name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.alumni.alumni_designation,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Posts: 100',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Skills',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: widget.alumni.skills
                        .map((skill) => Chip(
                              label: Text(skill),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.alumni.email,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Company',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.alumni.company,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Edit Profile Button without gradient
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality for editing profile
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    child: Text('Edit Profile',
                        style: TextStyle(color: color2566be)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Section for displaying posts
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
              ),
              itemCount: 12, // Replace with actual post count
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Text(
                      'Post $index',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
    ;
  }
}
