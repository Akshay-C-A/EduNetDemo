import 'dart:io';
import 'package:edunetdemo/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

class StudentNewPostPage extends StatefulWidget {
  const StudentNewPostPage({super.key});

  @override
  State<StudentNewPostPage> createState() => _StudentNewPostPageState();
}

class _StudentNewPostPageState extends State<StudentNewPostPage> {
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

  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return null;

    final storageRef = FirebaseStorage.instance.ref();
    final fileName = path.basename(_selectedImage!.path);
    final imageRef = storageRef.child('student_posts/$fileName');

    try {
      await imageRef.putFile(File(_selectedImage!.path));
      final downloadURL = await imageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  void _cancelImageSelection() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _resetForm() {
    _detailsController.clear();
    _organisationNameController.clear();
    setState(() {
      _selectedImage = null;
      _postType = 'Internship offers';
    });
  }

  Future<void> _submitPost() async {
    final imageURL = await _uploadImage();
    // await _firestoreService.addAlumniPosts(
    //   type: _postType,
    //   alumniName: 'John Doe', // Replace with the actual alumni name
    //   alumniDesignation:
    //       'Software Engineer', // Replace with the actual alumni designation
    //   caption: _organisationNameController.text,
    //   description: _detailsController.text,
    //   imageURL: imageURL,
    // );
    _resetForm();
    // Show a success message or navigate to the home page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 8.0),
              Row(
                children: [
                  IconButton(
                      onPressed: _pickImage, icon: Icon(Icons.upload_file)),
                  if (_selectedImage != null)
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Image.file(
                              File(_selectedImage!.path),
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                          IconButton(
                            onPressed: _cancelImageSelection,
                            icon: const Icon(Icons.cancel),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitPost,
                child: const Text('Submit'),
              ),
              const SizedBox(height: 16.0),
              IconButton(onPressed: _resetForm, icon: Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }
}