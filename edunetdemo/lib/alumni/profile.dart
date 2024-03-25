import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ProfilePage(
      alumni: Alumni(
        name: 'John Doe',
        designation: 'Software Engineer',
        skills: ['Flutter', 'Dart', 'Android', 'iOS'],
        email: 'john.doe@example.com',
        company: 'ABC Corporation',
        // Add profile photo asset path or URL
      ),
    ),
  ));
}

class ProfilePage extends StatelessWidget {
  final Alumni alumni;

  ProfilePage({required this.alumni});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(alumni.name), // Set title to alumni's name
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Color.fromARGB(255, 89, 99, 242),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile_photo.jpg'), // Add profile photo asset path or URL
                  ),
                  SizedBox(height: 10),
                  Text(
                    alumni.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    alumni.designation,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
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
                    children: alumni.skills
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
                    alumni.email,
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
                    alumni.company,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Alumni {
  final String name;
  final String designation;
  final List<String> skills;
  final String email;
  final String company;

  Alumni({
    required this.name,
    required this.designation,
    required this.skills,
    required this.email,
    required this.company,
  });
}