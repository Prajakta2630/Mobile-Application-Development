import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:momento/models/memory.dart';
import 'package:momento/utils/shared_prefs_helper.dart';
import 'dart:io';

class AddMemoryScreen extends StatefulWidget {
  @override
  _AddMemoryScreenState createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  DateTime? _selectedDate;
  String? _imagePath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        ) ??
        DateTime.now();

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _saveMemory() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _imagePath != null) {
      Memory memory = Memory(
        imagePath: _imagePath!,
        date: _selectedDate!,
        notes: _notesController.text,
        category: _categoryController.text,
        title: _titleController.text,
      );

      List<Memory> memories = await SharedPrefsHelper.getMemories();
      memories.add(memory);
      await SharedPrefsHelper.saveMemories(memories);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Memory saved successfully!')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Please fill all fields, select a date, and pick an image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Memory')),
      body: Container(
        color: Color(0xFF787FF6),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: _imagePath == null
                      ? Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.camera_alt,
                              color: Colors.white, size: 50),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_imagePath!),
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color.fromARGB(255, 120, 131, 251)),
                      color: Colors.blue[50],
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'Select Date'
                          : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some notes';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveMemory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 247, 250, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  child: Text('Save Memory', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
