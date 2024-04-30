import 'package:flutter/material.dart';

// Student class
class Student {
  final String name;
  final int age;
  final String email;

  Student({required this.name, required this.age, required this.email});
}

class EventParticipation extends StatefulWidget {
  const EventParticipation({super.key});

  @override
  State<EventParticipation> createState() => _EventParticipationState();
}

class _EventParticipationState extends State<EventParticipation> {
  // List to store enrolled students
  List<Student> enrolledStudents = [
    Student(name: 'John Doe', age: 20, email: 'john@example.com'),
    Student(name: 'Jane Smith', age: 22, email: 'jane@example.com'),
    Student(name: 'Bob Johnson', age: 21, email: 'bob@example.com'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Total no. of participants: ${enrolledStudents.length}'),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('No. of Enrolled students: ${enrolledStudents.length}'),
            ),
            SizedBox(height: 20),
            Text(
              'Participants',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: enrolledStudents.length,
                itemBuilder: (context, index) {
                  final student = enrolledStudents[index];
                  return ListTile(
                    title: Text(student.name),
                    subtitle: Text('Age: ${student.age}, Email: ${student.email}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}