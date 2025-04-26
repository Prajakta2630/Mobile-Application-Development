import 'dart:convert';

class Memory {
  final String? imagePath;
  final DateTime date;
  final String notes;
  final String category;
  final String title;

  Memory({
    this.imagePath,
    required this.date,
    required this.notes,
    required this.category,
    required this.title,
  });

  // Convert the Memory object to a map (for JSON encoding)
  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'date': date.toIso8601String(),
      'notes': notes,
      'category': category,
      'title': title,
    };
  }

  // Create a Memory object from a map (for JSON decoding)
  factory Memory.fromMap(Map<String, dynamic> map) {
    return Memory(
      imagePath: map['imagePath'] as String?,
      date: DateTime.parse(map['date'] as String),
      notes: map['notes'] as String? ?? '',
      category: map['category'] as String? ?? '',
      title: map['title'] as String? ?? '',
    );
  }

  // Convert the Memory object to a JSON string
  String toJson() => json.encode(toMap());

  // Create a Memory object from a JSON string
  factory Memory.fromJson(String source) =>
      Memory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Memory(imagePath: $imagePath, date: $date, notes: $notes, category: $category, title: $title)';
  }
}
