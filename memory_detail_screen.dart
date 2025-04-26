import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momento/models/memory.dart';
import 'edit_memory_screen.dart';
import 'dart:io';

class MemoryDetailScreen extends StatelessWidget {
  final Memory memory;
  final Function onMemoryUpdated;

  MemoryDetailScreen({required this.memory, required this.onMemoryUpdated});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditMemoryScreen(
                    memory: memory,
                    onMemoryUpdated: onMemoryUpdated,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Image
            _buildImage(),
            SizedBox(height: 16),

            // Display Title
            Text(
              memory.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Display Date
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(memory.date)}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),

            // Display Notes
            Text(
              'Notes: ${memory.notes}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            // Display Category
            Text(
              'Category: ${memory.category}',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return memory.imagePath != null && memory.imagePath!.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(memory.imagePath!),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          )
        : Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey[300],
            child: Icon(Icons.image, color: Colors.grey, size: 50),
          );
  }
}
