import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../activity_controller/activity_controller.dart';
import 'category_view.dart';
import 'map_view.dart';

class AddEditActivityView extends StatefulWidget {
  final Map<String, dynamic>? activity;

  AddEditActivityView({this.activity});

  @override
  _AddEditActivityViewState createState() => _AddEditActivityViewState();
}

class _AddEditActivityViewState extends State<AddEditActivityView> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _date;
  late String _location;
  late String _category;
  bool _done = false;
  late String _image;
  final ActivityController _controller = ActivityController();

  @override
  void initState() {
    super.initState();
    _title = widget.activity?['title'] ?? '';
    _description = widget.activity?['description'] ?? '';
    _date = DateTime.parse(widget.activity?['date'] ?? DateTime.now().toString());
    _location = widget.activity?['location'] ?? '';
    _category = widget.activity?['category'] ?? '';
    _done = widget.activity?['done'] == 1;
    _image = widget.activity?['image'] ?? '';
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.storage,
    ].request();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage.path; // Store the image path
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity == null ? 'Add Activity' : 'Edit Activity'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 12),
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 12),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Date: ${DateFormat('yyyy-MM-dd').format(_date)}',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      Icon(Icons.calendar_today, color: Colors.black),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapView(),
                    ),
                  ).then((selectedLocation) {
                    if (selectedLocation != null) {
                      setState(() {
                        _location = '${selectedLocation.latitude},${selectedLocation.longitude}';
                      });
                    }
                  });
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _location.isNotEmpty ? _location : 'Select Location',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.location_on, color: Colors.black),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category.isNotEmpty ? _category : 'Optional',
                items: ['Important', 'Normal', 'Optional'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
                onSaved: (value) {
                  _category = value!;
                },
              ),
              SizedBox(height: 12),
              Row(
                children: <Widget>[
                  _image == ''
                      ? Text('No image selected.')
                      : Image.file(File(_image!), height: 100, width: 100),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Select Image'),
                  ),
                ],
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.activity == null) {
                      await _controller.handleAddButtonClick(
                        _title,
                        _description,
                        _date,
                        _location,
                        _category,
                        _image,
                      );
                    } else {
                      _controller.handleEditButtonClick(
                        widget.activity!['id'],
                        _title,
                        _description,
                        _date,
                        _location,
                        _category,
                        _done,
                        _image,
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.activity == null ? 'Add Activity' : 'Update Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
