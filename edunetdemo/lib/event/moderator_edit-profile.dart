import 'package:edunetdemo/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ModeratorEditProfileForm extends StatefulWidget {
  @override
  _ModeratorEditProfileFormState createState() => _ModeratorEditProfileFormState();
}

class _ModeratorEditProfileFormState extends State<ModeratorEditProfileForm> {
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

class ModeratorEditPostForm extends StatefulWidget {
  final String moderatorId;
  final String postId;
  const ModeratorEditPostForm({
    super.key,
    required this.moderatorId,
    required this.postId,
  });

  @override
  State<ModeratorEditPostForm> createState() => _ModeratorEditPostFormState();
}

class _ModeratorEditPostFormState extends State<ModeratorEditPostForm> {
  final _firestoreService = FirestoreService();
  late final TextEditingController _dateController;
  late final TextEditingController _eventTitleController;
  late final TextEditingController _eventVenueController;
  late final TextEditingController _otherDetailsController;

  Map<String, dynamic>? _postData;

  @override
  void initState() {
    super.initState();
    _fetchPost();
    _dateController = TextEditingController();
    _eventTitleController = TextEditingController();
    _eventVenueController = TextEditingController();
    _otherDetailsController = TextEditingController();
  }

  Future<void> _fetchPost() async {
    final postSnapshot = await _firestoreService.getModeratorPost(
      moderatorId: widget.moderatorId,
      postId: widget.postId,
    );

    if (postSnapshot.exists) {
      setState(() {
        _postData = postSnapshot.data() as Map<String, dynamic>;
        _dateController =
            TextEditingController(text: _postData!['date'] as String);
        _eventTitleController =
            TextEditingController(text: _postData!['eventTitle'] as String);
        _eventVenueController =
            TextEditingController(text: _postData!['eventVenue'] as String);
        _otherDetailsController =
            TextEditingController(text: _postData!['otherDetails'] as String);
      });
    } else {
      setState(() {
        _postData = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post not found'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _updatePost() async {
    await _firestoreService.updateEventPost(
      postId: widget.postId,
      moderatorId: widget.moderatorId,
      Date: _dateController.text,
      Venue: _eventVenueController.text,
      otherDetails: _otherDetailsController.text,
      EventTitle: _eventTitleController.text,
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _eventTitleController.dispose();
    _eventVenueController.dispose();
    _otherDetailsController.dispose();
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
                : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Event Title', _eventTitleController),
                    SizedBox(height: 16.0),
                    _buildTextFieldWithCalendarIcon('Event Date'),
                    SizedBox(height: 16.0),
                    _buildTextField('Event Venue', _eventVenueController),
                    SizedBox(height: 16.0),
                    _buildTextField('Other Details', _otherDetailsController),
                    SizedBox(height: 16.0),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text('Clear'),
                        ),
                        const SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: _updatePost,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                          ),
                          child: const Text('Update'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldWithCalendarIcon(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: _dateController,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: _pickDate,
              icon: Icon(Icons.calendar_today),
            ),
          ),
        ),
      ],
    );
  }

  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }
}