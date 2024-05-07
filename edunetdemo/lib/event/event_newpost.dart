import 'dart:io';
import 'package:edunetdemo/event/moderator_profile.dart';
import 'package:edunetdemo/services/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class EventNewPostPage extends StatefulWidget {
  final Moderator moderator;
  const EventNewPostPage({super.key, required this.moderator});
  @override
  State<EventNewPostPage> createState() => _EventNewPostPageState();
}

class _EventNewPostPageState extends State<EventNewPostPage> {
  final FirestoreService _EventFirestoreService = FirestoreService();

  String _eventTitle = '';
  String _eventDate = '';
  String _eventVenue = '';
  String? _otherDetails;
  bool _submitted = false;
  bool _isPayment = false;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _eventTitleController = TextEditingController();
  TextEditingController _eventVenueController = TextEditingController();
  TextEditingController _otherDetailsController = TextEditingController();
  TextEditingController _paymentsController = TextEditingController();

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
    _dateController.clear();
    _eventTitleController.clear();
    _eventVenueController.clear();
    _otherDetailsController.clear();
    _paymentsController.clear();

    setState(() {
      _selectedImage = null;
      _isPayment = false;
    });
  }

  Future<void> _submitPost() async {
    setState(() {
      _isLoading = true;
    });

    final imageURL = await _uploadImage();

    await _EventFirestoreService.addEventPosts(
      communityName: widget.moderator.communityName,
      EventTitle: _eventTitleController.text,
      moderatorId: widget.moderator.moderatorId,
      moderatorName: widget.moderator.moderatorName,
      Date: _dateController.text,
      Venue: _eventVenueController.text,
      otherDetails: _otherDetailsController.text,
      imageURL: imageURL,
      dpURL: widget.moderator.dpURL,
      payment: _paymentsController.text,
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
                    const SizedBox(height: 16.0),
                    _buildTextFormField('Event Title',
                        (value) => _eventTitle = value!, _eventTitleController),
                    SizedBox(height: 16.0),
                    _buildTextFieldWithCalendarIcon(
                        'Event Date', (value) => _eventDate = value!),
                    SizedBox(height: 16.0),
                    _buildTextFormField('Event Venue',
                        (value) => _eventVenue = value!, _eventVenueController),
                    SizedBox(height: 16.0),
                    _buildTextField(
                        'Other Details',
                        (value) => _otherDetails = value,
                        _otherDetailsController),
                    SizedBox(height: 16.0),
                    Text(
                      'Registration Fee?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio(
                              // title: Text('No'),
                              value: false,
                              groupValue: _isPayment,
                              onChanged: (value) {
                                setState(() {
                                  _isPayment = false;
                                });
                              },
                            ),
                            Text('No'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              // title: Text('No'),
                              value: true,
                              groupValue: _isPayment,
                              onChanged: (value) {
                                setState(() {
                                  _isPayment = true;
                                });
                              },
                            ),
                            Text('Yes'),
                          ],
                        ),
                      ],
                    ),

                    // RadioListTile(
                    //   title: Text('Yes'),
                    //   value: true,
                    //   groupValue: _isPayment,
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _isPayment = true;
                    //     });
                    //   },
                    // ),
                    SizedBox(height: 16.0),
                    _isPayment
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Amount',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextFormField(
                                controller: _paymentsController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Amount',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Amount should be entered';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'You must enter a numeric value';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.0),
                            ],
                          )
                        : Container(),
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
                          onPressed: (){
                            if(_dateController.text.isEmpty || _eventTitleController.text.isEmpty||_eventVenueController.text.isEmpty|| _selectedImage==null){
                            ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enter all the fields to submit'),
          duration: Duration(seconds: 3),
        ),
      );}
                            else
                                                        _submitPost();
},
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

  Widget _buildTextField(String label, Function(String?) onSaved,
      TextEditingController t_controller) {
    bool showError = _submitted &&
        (label == 'Event Title'
            ? _eventTitle.isEmpty
            : (label == 'Event Date'
                ? _eventDate.isEmpty
                : label == 'Event Venue'
                    ? _eventVenue.isEmpty
                    : false));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextField(
          maxLines: null,
          controller: t_controller,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(),
            errorBorder: showError
                ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                : OutlineInputBorder(),
            errorText: showError ? 'This field is required' : null,
          ),
          // onSaved: onSaved,
          // validator: (value) {
          //   if (_submitted &&
          //       (value == null || value.isEmpty) &&
          //       (label == 'Event Title' ||
          //           label == 'Event Date' ||
          //           label == 'Event Venue')) {
          //     return 'This field is required';
          //   }
          //   return null;
          // },
        ),
      ],
    );
  }

  Widget _buildTextFormField(String label, Function(String?) onSaved,
      TextEditingController t_controller) {
    bool showError = _submitted &&
        (label == 'Event Title'
            ? _eventTitle.isEmpty
            : (label == 'Event Date'
                ? _eventDate.isEmpty
                : label == 'Event Venue'
                    ? _eventVenue.isEmpty
                    : false));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: t_controller,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(),
            errorBorder: showError
                ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                : OutlineInputBorder(),
            errorText: showError ? 'This field is required' : null,
          ),
          onSaved: onSaved,
          validator: (value) {
            if (_submitted &&
                (value == null || value.isEmpty) &&
                (label == 'Event Title' ||
                    label == 'Event Date' ||
                    label == 'Event Venue')) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextFieldWithCalendarIcon(
      String label, Function(String?) onSaved) {
    bool showError = _submitted && _eventDate.isEmpty;
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
            errorBorder: showError
                ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red))
                : OutlineInputBorder(),
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
        _dateController.text = _eventDate;
      });
    }
  }
}
