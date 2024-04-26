import 'dart:io';
import 'package:edunetdemo/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EventNewPostPage extends StatefulWidget {
  @override
  State<EventNewPostPage> createState() => _EventNewPostPageState();
}

class _EventNewPostPageState extends State<EventNewPostPage> {
  final FirestoreService _EventFirestoreService = FirestoreService();
  final _detailsController = TextEditingController();
  final _captionController = TextEditingController();
  String _postType = 'Internship offer';

  XFile? _selectedImage;
  final _picker = ImagePicker();
  bool _isLoading = false;

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
    _captionController.clear();
    setState(() {
      _selectedImage = null;
      _postType = 'Internship offer';
    });
  }

  Future<void> _submitPost() async {
    setState(() {
      _isLoading = true;
    });

    final imageURL = await _uploadImage();
    await _EventFirestoreService.addEventPosts(
      EventTitle: 'Event Title 22', 
      moderatorId: 'mod123', 
      moderatorName: 'modmemms', 
      Date: '21/21/2121', 
      Venue: 'Event Venue 22', 
      otherDetails: 'Other Details 22',
      imageURL: 'https://png.pngtree.com/thumb_back/fh260/background/20230611/pngtree-two-cute-egg-cupids-sitting-in-sunlight-next-to-each-other-image_2914931.jpg',
      dpURL: 'https://png.pngtree.com/thumb_back/fh260/background/20230611/pngtree-two-cute-egg-cupids-sitting-in-sunlight-next-to-each-other-image_2914931.jpg',
      
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
                    const Text(
                      'Post Type',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
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
                      'Caption',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: _captionController,
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
                          onPressed: _pickImage,
                          icon: const Icon(Icons.photo_library),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _resetForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text('Clear'),
                        ),
                        const SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: _submitPost,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                          ),
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
