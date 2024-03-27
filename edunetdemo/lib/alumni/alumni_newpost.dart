// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class AlumniNewPostPage extends StatefulWidget {
//   const AlumniNewPostPage({super.key});

//   @override
//   State<AlumniNewPostPage> createState() => _AlumniNewPostPageState();
// }

// class _AlumniNewPostPageState extends State<AlumniNewPostPage> {
//   final _detailsController = TextEditingController();
//   final _organisationNameController = TextEditingController();
//   String _postType = 'Internship offers';
//   final List<String> _postTypes = [
//     'Internship offers',
//     'Placement offers',
//     'Technical events',
//     // 'My achievements'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Post'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Handle post creation logic here
//             },
//             child: const Text(
//               'Post',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16.0,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Post Type',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8.0),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 border: Border.all(color: Colors.grey),
//               ),
//               child: DropdownButton<String>(
//                 value: _postType,
//                 isExpanded: true,
//                 underline: const SizedBox.shrink(),
//                 items: _postTypes.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _postType = newValue!;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             const Text(
//               'Details',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             TextField(
//               controller: _detailsController,
//               decoration: const InputDecoration(
//                 hintText: 'Enter details',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: null,
//             ),
//             const SizedBox(height: 16.0),
//             const Text(
//               'Organisation Name',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             TextField(
//               controller: _organisationNameController,
//               decoration: const InputDecoration(
//                 hintText: 'Enter organisation name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             const Text(
//               'Photo',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8.0),
// ElevatedButton(
//   onPressed: () async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);

//     if (image != null) {
//       // Handle the selected image here
//       print('Selected image path: ${image.path}');
//     }
//   },
//   child: const Text('Upload Photo'),
// ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AlumniNewPostPage extends StatefulWidget {
  const AlumniNewPostPage({super.key});

  @override
  State<AlumniNewPostPage> createState() => _AlumniNewPostPageState();
}

class _AlumniNewPostPageState extends State<AlumniNewPostPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: () {
              // Handle post creation logic here
            },
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
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
            ElevatedButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                if (image != null) {
                  setState(() {
                    _selectedImage = image;
                  });
                }
              },
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
          ],
        ),
      ),
    );
  }
}