import 'package:flutter/material.dart';
import 'package:momento/models/memory.dart';
import 'package:momento/utils/shared_prefs_helper.dart';
import 'add_memory_screen.dart';
import 'memory_detail_screen.dart';
import 'profile_page.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Memory> _memories = [];
  String _viewType = 'list';

  final List<Color> _cardColors = [
    Color.fromARGB(255, 253, 83, 145),
    Color.fromARGB(255, 255, 221, 111),
    Color.fromARGB(255, 160, 241, 255),
  ];

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  void _loadMemories() async {
    List<Memory> memories = await SharedPrefsHelper.getMemories();
    setState(() {
      _memories = memories;
      print('HomeScreen memories updated: ${_memories.length} memories loaded');
    });
  }

  void _switchView(String viewType) {
    setState(() {
      _viewType = viewType;
    });
  }

  void _navigateToMemoryDetail(Memory memory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoryDetailScreen(
          memory: memory,
          onMemoryUpdated: _loadMemories,
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: _memories.length,
      itemBuilder: (context, index) {
        final memory = _memories[index];
        final colorIndex = index % _cardColors.length;
        return Card(
          margin: EdgeInsets.symmetric(vertical: 12),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: _cardColors[colorIndex],
          child: ListTile(
            contentPadding: EdgeInsets.all(20),
            leading: memory.imagePath != null && memory.imagePath!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(File(memory.imagePath!),
                        width: 60, height: 60, fit: BoxFit.cover),
                  )
                : Icon(Icons.image,
                    color: const Color.fromARGB(255, 254, 254, 254), size: 60),
            title: Text(
              memory.title, // Changed from memory.notes to memory.title
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            trailing: Text(
              memory.category,
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6A1B9A),
                  fontWeight: FontWeight.w500),
            ),
            onTap: () => _navigateToMemoryDetail(memory),
          ),
        );
      },
    );
  }

  Widget _buildGalleryView() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        itemCount: _memories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final memory = _memories[index];
          final colorIndex = index % _cardColors.length;
          return GestureDetector(
            onTap: () => _navigateToMemoryDetail(memory),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: _cardColors[colorIndex],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  memory.imagePath != null && memory.imagePath!.isNotEmpty
                      ? ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                          child: Image.file(
                            File(memory.imagePath!),
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child:
                              Icon(Icons.image, color: Colors.grey, size: 60),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      memory.title, // Changed from memory.notes to memory.title
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      memory.category,
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6A1B9A),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelineView() {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: _memories.length,
      itemBuilder: (context, index) {
        final memory = _memories[index];
        final colorIndex = index % _cardColors.length;
        return GestureDetector(
          onTap: () => _navigateToMemoryDetail(memory),
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 12),
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: _cardColors[colorIndex],
            child: ListTile(
              contentPadding: EdgeInsets.all(20),
              leading: Icon(Icons.favorite, color: Colors.black87, size: 40),
              title: Text(
                memory.title, // Changed from memory.notes to memory.title
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
              trailing: Text(
                memory.category,
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6A1B9A),
                    fontWeight: FontWeight.w500),
              ),
              onTap: () => _navigateToMemoryDetail(memory),
            ),
          ),
        );
      },
    );
  }

  void _showViewTypeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select View Type",
              style: TextStyle(color: Color(0xFF6A1B9A))),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    Icon(Icons.format_list_bulleted, color: Colors.pinkAccent),
                title:
                    Text("List View", style: TextStyle(color: Colors.black87)),
                onTap: () {
                  _switchView('list');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera, color: Colors.orangeAccent),
                title: Text("Gallery View",
                    style: TextStyle(color: Colors.black87)),
                onTap: () {
                  _switchView('gallery');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.timeline, color: Colors.tealAccent),
                title: Text("Timeline View",
                    style: TextStyle(color: Colors.black87)),
                onTap: () {
                  _switchView('timeline');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Momento',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
        backgroundColor: Color(0xFF787FF6),
        elevation: 6,
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: _showViewTypeDialog,
            tooltip: 'Change View',
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD1ECF1), Color(0xFF6A9AF6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _viewType == 'list'
            ? _buildListView()
            : _viewType == 'gallery'
                ? _buildGalleryView()
                : _buildTimelineView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMemoryScreen()),
          );
          if (result == true) {
            _loadMemories();
          }
        },
        child: Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
