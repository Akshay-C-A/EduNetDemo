import 'package:flutter/material.dart';

class AlumniNewPostPage extends StatefulWidget {
  const AlumniNewPostPage({super.key});

  @override
  State<AlumniNewPostPage> createState() => _AlumniNewPostPageState();
}

class _AlumniNewPostPageState extends State<AlumniNewPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Text('Alumni Post ')),
    );
  }
}
