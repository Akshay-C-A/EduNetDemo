import 'dart:io';

import 'package:edunetdemo/alumni/alumni_dashboard.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AlumniNewPostPage extends StatefulWidget {
  final Alumni alumni;
  const AlumniNewPostPage({super.key, required this.alumni});

  @override
  State<AlumniNewPostPage> createState() => _AlumniNewPostPageState();
}

class _AlumniNewPostPageState extends State<AlumniNewPostPage> {
  final _AlumniFirestoreService = FirestoreService();

  final _nameController = TextEditingController();
  final _designationController = TextEditingController();
  final _skillsController = TextEditingController();
  final _companyController = TextEditingController();
  final _aboutController = TextEditingController();
  final _link1Controller = TextEditingController();
  final _link2Controller = TextEditingController();
  final _link3Controller = TextEditingController();

  // String _postType = 'Internship offers';
  // final List<String> _postTypes = [
  //   'Internship offers',
  //   'Placement offers',
  //   'Technical events',
  //   // 'My achievements'
  // ];
  XFile? _selectedImage;
  final _picker = ImagePicker();
  bool _isLoading = false;

  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return null;

    final storageRef = FirebaseStorage.instance.ref();
    final fileName = path.basename(_selectedImage!.path);
    final imageRef = storageRef.child('alumni_profile/$fileName');

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
    _nameController.clear();
  final _designationController = TextEditingController();
  final _skillsController = TextEditingController();
  final _companyController = TextEditingController();
  final _aboutController = TextEditingController();
  final _link1Controller = TextEditingController();
  final _link2Controller = TextEditingController();
  final _link3Controller
    _Controller.clear();
    _organisationNameController.clear();
    // setState(() {
    //   _selectedImage = null;
    //   _postType = 'Internship offers';
    // });
  }

  Future<void> _submitPost() async {
    setState(() {
      _isLoading = true;
    });

    final imageURL = await _uploadImage();
    await _AlumniFirestoreService.addAlumniPosts(
      type: _postType,
      alumniId: widget.alumni.alumniId,
      alumniName: widget.alumni.alumni_name,
      alumniDesignation: widget.alumni.alumni_designation,
      caption: _organisationNameController.text,
      description: _detailsController.text,
      imageURL: imageURL,
    );

    setState(() {
      _isLoading = false;
    });

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New post added'),
        duration: Duration(seconds: 2),
      ),
    );

    _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: SpinKitFadingCircle(
                color: Theme.of(context).primaryColor,
                size: 50.0,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text(
                    //   'Post Type',
                    //   style: TextStyle(
                    //     fontSize: 18.0,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // const SizedBox(height: 8.0),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(8.0),
                    //     border: Border.all(color: Colors.grey),
                    //   ),
                    //   child: DropdownButton<String>(
                    //     value: _postType,
                    //     isExpanded: true,
                    //     underline: const SizedBox.shrink(),
                    //     items: _postTypes.map((String value) {
                    //       return DropdownMenuItem<String>(
                    //         value: value,
                    //         child: Text(value),
                    //       );
                    //     }).toList(),
                    //     onChanged: (String? newValue) {
                    //       setState(() {
                    //         _postType = newValue!;
                    //       });
                    //     },
                    //   ),
                    // ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Designation',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: _designationController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Current Designation',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const Text(
                      'Designation',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: _skillsController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Current Designation',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const Text(
                      'Designation',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: _companyController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Current Designation',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const Text(
                      'Designation',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: _aboutController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Current Designation',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const Text(
                      'Designation',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: _link1Controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter Current Designation',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const Text(
                      'Designation',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: _link2Controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter Current Designation',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const Text(
                      'Designation',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: _link3Controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter Current Designation',
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
                          onPressed: _pickImage,
                          icon: Icon(Icons.upload_file),
                        ),
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
                    IconButton(
                      onPressed: _resetForm,
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
