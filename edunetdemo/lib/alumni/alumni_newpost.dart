import 'dart:io';
import 'package:edunetdemo/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

class AlumniNewPostPage extends StatefulWidget {
  const AlumniNewPostPage({super.key});

  @override
  State<AlumniNewPostPage> createState() => _AlumniNewPostPageState();
}

class _AlumniNewPostPageState extends State<AlumniNewPostPage> {
  final _firestoreService = FirestoreService();
  final _detailsController = TextEditingController();
  final _organisationNameController = TextEditingController();
  String _postType = 'Internship offers';
  final List<String> _postTypes = [
    'Internship offers',
    'Placement offers',
    'Technical events',
    // 'My achievements'
  ];
  XFile? _selectedImage;
  final _picker = ImagePicker();
////////////////////////////////////
Future<String?> _uploadImage() async {
  if (_selectedImage == null) return null;

  final storageRef = FirebaseStorage.instance.ref();
  final fileName = path.basename(_selectedImage!.path);
  final imageRef = storageRef.child('alumni_posts/$fileName');

  try {
    await imageRef.putFile(File(_selectedImage!.path));
    final downloadURL = await imageRef.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}
////////////////////////////////////
Future<void> _pickImage() async {
  final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    setState(() {
      _selectedImage = pickedImage;
    });
  }
}
///////////////////////////////////
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Create Post'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... (existing code)
                      const Text(
              'Post Type',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButton<String>(
                value: _postType,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                items: _postTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _postType = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Details',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _detailsController,
              decoration: const InputDecoration(
                hintText: 'Enter details',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Organisation Name',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _organisationNameController,
              decoration: const InputDecoration(
                hintText: 'Enter organisation name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Photo',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 16.0),
                    ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Upload Photo'),
          ),
          if (_selectedImage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Image.file(
                File(_selectedImage!.path),
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              final imageURL = await _uploadImage();
              await _firestoreService.addAlumniPosts(
                type: _postType,
                alumniName: 'John Doe', // Replace with the actual alumni name
                alumniDesignation: 'Software Engineer', // Replace with the actual alumni designation
                caption: _organisationNameController.text,
                description: _detailsController.text,
                imageURL: imageURL,
              );
              // Reset the form fields
              _detailsController.clear();
              _organisationNameController.clear();
              setState(() {
                _selectedImage = null;
              });
              // Show a success message or navigate to the home page
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    ),
  );
}
}

