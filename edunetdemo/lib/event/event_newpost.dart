import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class EventNewPost extends StatefulWidget {
  const EventNewPost({Key? key}) : super(key: key);

  @override
  State<EventNewPost> createState() => _EventNewPostState();
}

class _EventNewPostState extends State<EventNewPost> {
  final _formKey = GlobalKey<FormState>();
  String _eventTitle = '';
  String _eventDate = '';
  String _eventVenue = '';
  String? _otherDetails;
  File? _imageFile;
  bool _submitted = false;
  TextEditingController _dateController = TextEditingController(); // Controller for event date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        actions: [
          TextButton(
            onPressed: _submitForm,
            child: Text(
              'Post',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Event Title', (value) => _eventTitle = value!),
                SizedBox(height: 16.0),
                _buildTextFieldWithCalendarIcon('Event Date', (value) => _eventDate = value!),
                SizedBox(height: 16.0),
                _buildTextField('Event Venue', (value) => _eventVenue = value!),
                SizedBox(height: 16.0),
                _buildTextField('Other Details', (value) => _otherDetails = value),
                SizedBox(height: 16.0),
                Text(
                  'Photo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Center(
                  child: _buildImagePicker(),
                ),
                SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    setState(() {
      _submitted = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Perform post submission logic here
      print('Event Title: $_eventTitle');
      print('Event Date: $_eventDate');
      print('Event Venue: $_eventVenue');
      print('Other Details: $_otherDetails');
      print('Image File: ${_imageFile?.path}');
    }
  }

  Widget _buildTextField(String label, Function(String?) onSaved) {
    bool showError = _submitted && (label == 'Event Title' ? _eventTitle.isEmpty : (label == 'Event Date' ? _eventDate.isEmpty : label == 'Event Venue' ? _eventVenue.isEmpty : false));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(),
            errorBorder: showError ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red)) : OutlineInputBorder(),
            errorText: showError ? 'This field is required' : null,
          ),
          onSaved: onSaved,
          validator: (value) {
            if (_submitted && (value == null || value.isEmpty) && (label == 'Event Title' || label == 'Event Date' || label == 'Event Venue')) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextFieldWithCalendarIcon(String label, Function(String?) onSaved) {
    bool showError = _submitted && _eventDate.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: _dateController, // Assign controller
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(),
            errorBorder: showError ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red)) : OutlineInputBorder(),
            errorText: showError ? 'This field is required' : null,
            suffixIcon: label == 'Event Date'
                ? IconButton(
                    onPressed: _pickDate,
                    icon: Icon(Icons.calendar_today),
                  )
                : null,
          ),
          onSaved: onSaved,
          validator: (value) {
            if (_submitted && value!.isEmpty && label == 'Event Date') {
              return 'This field is required';
            }
            return null;
          },
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
        _eventDate = DateFormat('dd/MM/yyyy').format(pickedDate);
        _dateController.text = _eventDate; // Update text field value
      });
    }
  }

  Widget _buildImagePicker() {
    return _imageFile == null
        ? ElevatedButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.upload),
            label: Text('Upload Photo'),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _pickImage,
                icon: Icon(Icons.upload),
              ),
              Image.file(
                _imageFile!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _imageFile = null;
                  });
                },
                icon: Icon(Icons.close),
              ),
            ],
          );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: EventNewPost(),
  ));
}
