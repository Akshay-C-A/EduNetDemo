import 'package:edunetdemo/services/firestore.dart';
import 'package:flutter/material.dart';

class EditModeratorProfileForm extends StatefulWidget {
  @override
  _EditModeratorProfileFormState createState() => _EditModeratorProfileFormState();
}

class _EditModeratorProfileFormState extends State<EditModeratorProfileForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _designationController = TextEditingController();
  TextEditingController _skillsController = TextEditingController();
  TextEditingController _companyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  // You can add additional email validation logic here if needed
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _designationController,
                decoration: InputDecoration(labelText: 'Designation'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _skillsController,
                decoration: InputDecoration(labelText: 'Skills'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _companyController,
                decoration: InputDecoration(labelText: 'Company Name'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save form data to database or perform any other action
                    // For demonstration, we're just printing the values
                    print('Name: ${_nameController.text}');
                    print('Email: ${_emailController.text}');
                    print('Designation: ${_designationController.text}');
                    print('Skills: ${_skillsController.text}');
                    print('Company: ${_companyController.text}');
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the Widget is disposed
    _nameController.dispose();
    _emailController.dispose();
    _designationController.dispose();
    _skillsController.dispose();
    _companyController.dispose();
    super.dispose();
  }
}

class EditEventPostForm extends StatefulWidget {
  final String alumniId;
  final String postId;
  const EditEventPostForm({
    super.key,
    required this.alumniId,
    required this.postId,
  });

  @override
  State<EditEventPostForm> createState() => _EditPostFormState();
}

class _EditPostFormState extends State<EditEventPostForm> {
  final _firestoreService = FirestoreService();
  late final TextEditingController _detailsController;
  late final TextEditingController _captionController;

  Map<String, dynamic>? _postData;

  @override
  void initState() {
    super.initState();
    _fetchPost();
  }

  String _postType = 'Internship offer';
  final List<String> _postTypes = [
    'Internship offer',
    'Placement offer',
    'Technical event',
    // 'My achievements'
  ];

  Future<void> _fetchPost() async {
    final postSnapshot = await _firestoreService.getAlumniPost(
      alumniId: widget.alumniId,
      postId: widget.postId,
    );

    if (postSnapshot.exists) {
      setState(() {
        _postData = postSnapshot.data() as Map<String, dynamic>;
        _detailsController =
            TextEditingController(text: _postData!['description'] as String);
        _captionController =
            TextEditingController(text: _postData!['caption'] as String);
        _postType = _postData!['type'] as String;
      });
    } else {
      // Handle the case when the post is not found
      setState(() {
        _postData = null;
        _detailsController = TextEditingController();
        _captionController = TextEditingController();
      });

      // Show a snackbar or dialog to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post not found'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _updatePost() async {
    await _firestoreService.updateAlumniPost(
      postId: widget.postId,
      type: _postType,
      alumniId: widget.alumniId,
      caption: _captionController.text,
      description: _detailsController.text,
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _detailsController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: Center(
        child: FutureBuilder(
          future: _fetchPost(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? CircularProgressIndicator()
                : Padding(
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
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Center(
                          child: TextButton(
                            onPressed: _updatePost,
                            child: const Text('Update'),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
