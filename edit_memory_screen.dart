import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:momento/models/memory.dart';
import 'package:momento/utils/shared_prefs_helper.dart';
import 'dart:io';

class EditMemoryScreen extends StatefulWidget {
  final Memory memory;
  final Function onMemoryUpdated;

  EditMemoryScreen({required this.memory, required this.onMemoryUpdated});

  @override
  _EditMemoryScreenState createState() => _EditMemoryScreenState();
}

class _EditMemoryScreenState extends State<EditMemoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController; // Added for title
  late TextEditingController _notesController;
  late TextEditingController _categoryController;
  late DateTime _selectedDate;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
        text: widget.memory.title); // Initialize with existing title
    _notesController = TextEditingController(text: widget.memory.notes);
    _categoryController = TextEditingController(text: widget.memory.category);
    _selectedDate = widget.memory.date;
    _imagePath = widget.memory.imagePath;
  }

  // Pick an image using ImagePicker
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  // Show Date Picker for selecting date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        ) ??
        _selectedDate;

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  // Save the updated memory
  Future<void> _saveMemory() async {
    if (_formKey.currentState!.validate()) {
      Memory updatedMemory = Memory(
        imagePath: _imagePath,
        date: _selectedDate,
        notes: _notesController.text,
        category: _categoryController.text,
        title: _titleController.text, // Added title
      );

      List<Memory> memories = await SharedPrefsHelper.getMemories();
      int index = memories.indexWhere((m) => m.date == widget.memory.date);
      if (index != -1) {
        memories[index] = updatedMemory;
        await SharedPrefsHelper.saveMemories(memories);
        widget.onMemoryUpdated();
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Memory')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: _imagePath != null && _imagePath!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_imagePath!),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.camera_alt,
                            color: Colors.white, size: 50),
                      ),
              ),
              SizedBox(height: 16),

              // Date Picker
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
                    color: Colors.blue[50],
                  ),
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(_selectedDate),
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Title Field (New)
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Notes Field
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some notes';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Category Field
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: _saveMemory,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
