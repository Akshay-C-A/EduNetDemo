import 'dart:io';
import 'package:edunetdemo/services/firestore.dart';
import 'package:edunetdemo/student/student_dashboard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

// import 'package:shared_preferences/shared_preferences.dart';

class StudentProfileForm extends StatefulWidget {
  const StudentProfileForm({
    super.key,
  });

  @override
  State<StudentProfileForm> createState() => _StudentProfileFormState();
}

class _StudentProfileFormState extends State<StudentProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _Student = FirestoreService();
  final currentUser = FirebaseAuth.instance.currentUser;

  final _nameController = TextEditingController();
  final _designationController = TextEditingController();
  final _skillsController = TextEditingController();
  final _aboutController = TextEditingController();
  final _deptController = TextEditingController();
  final _yearController = TextEditingController();
  final _link1Controller = TextEditingController();
  final _link2Controller = TextEditingController();
  final _link3Controller = TextEditingController();
  late List<String> skills = [];

  // String _postType = 'Internship offers';
  // final List<String> _postTypes = [
  //   'Internship offers',
  //   'Placement offers',
  //   'Technical events',
  //   // 'My achievements'
  // ];

// Validator function to check if the input contains only alphabets and is not empty
  String? _validateAlphabets(String? value) {
    if (value != null && value.isNotEmpty) {
      // Regular expression to match only alphabets
      final alphaRegex = RegExp(r'^[a-zA-Z]+$');
      if (!alphaRegex.hasMatch(value)) {
        return 'Only alphabets are allowed';
      }
    } else {
      return 'This field is required';
    }
    return null;
  }

  XFile? _selectedImage;
  final _picker = ImagePicker();
  bool _isLoading = false;

  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return null;

    final storageRef = FirebaseStorage.instance.ref();
    final fileName = path.basename(_selectedImage!.path);
    final imageRef = storageRef.child('student_profile/$fileName');

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
    _designationController.clear();
    _skillsController.clear();
    _aboutController.clear();
    _deptController.clear();
    _yearController.clear();
    _link1Controller.clear();
    _link2Controller.clear();
    _link3Controller.clear();

    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {

    setState(() {
      _isLoading = true;
    });
    String skillsInput = _skillsController.text.trim();
    skills = skillsInput.split(',').map((skill) => skill.trim()).toList();
    final imageURL = await _uploadImage();
    await  _Student.addStudent(
      studentName: _nameController.text,
      studentDesignation: _designationController.text,
      skills: skills,
      studentMail: currentUser!.email,
      about: _aboutController.text,
      studentDept: _deptController.text,
      studentYear: _yearController.text,
      dpURL: imageURL ??
          'data:image/png;base64,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',
      linkedIn: _link1Controller.text,
      twitter: _link2Controller.text,
      mail: _link3Controller.text,
  );

    await FirebaseAuth.instance.currentUser!.updateDisplayName(_nameController.text);

    setState(() {
      _isLoading = false;
    });

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile Updated'),
        duration: Duration(seconds: 2),
      ),
    );

    _resetForm();
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('hasCompletedProfileForm', true);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Student_Dashboard()));
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                child: Form(
                  key:_formKey,
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
                      TextFormField(
                        controller: _nameController,
                        validator: _validateAlphabets,
                        decoration: const InputDecoration(
                          hintText: 'Enter your name',
                          border: OutlineInputBorder(),
                        ),
                  
                        maxLines: null,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Department',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _deptController,
                        validator: _validateAlphabets,
                        decoration: const InputDecoration(
                          hintText: 'Enter your department',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Year',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _yearController,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Year is required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Year must be a number';
                      }
                      return null;
                    },
                        decoration: const InputDecoration(
                          hintText: 'Year of study',
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
                      TextFormField(
                        controller: _designationController,
                        validator: _validateAlphabets,
                        decoration: const InputDecoration(
                          hintText: 'Enter Current Designation',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Text(
                        'Skills',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _skillsController,
                         validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Skills are required';
                      }
                      return null;
                    },
                        decoration: const InputDecoration(
                          hintText: 'Enter Skills',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: _aboutController,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'About is required';
                      }
                      return null;
                    },
                        decoration: const InputDecoration(
                          hintText: 'Enter About',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Text(
                        'LinkedIn',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _link1Controller,
                        decoration: const InputDecoration(
                          hintText: 'Enter LinkedIn link or username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Text(
                        'Twitter',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _link2Controller,
                        decoration: const InputDecoration(
                          hintText: 'Enter Twitter link or username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Text(
                        'Mail Id',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _link3Controller,
                        decoration: const InputDecoration(
                          hintText: 'Enter Mail Id',
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
            ),
    );
  }
}
