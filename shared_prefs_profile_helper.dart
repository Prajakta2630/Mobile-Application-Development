import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momento/models/memory.dart';

class SharedPrefsHelper {
  // Save a list of memories to SharedPreferences
  static Future<void> saveMemories(List<Memory> memories) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> memoriesJson =
          memories.map((memory) => json.encode(memory.toMap())).toList();
      await prefs.setStringList('memories', memoriesJson);
    } catch (e) {
      print("Error saving memories: $e");
      throw Exception("Failed to save memories: $e");
    }
  }

  // Retrieve the list of memories from SharedPreferences
  static Future<List<Memory>> getMemories() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? memoriesJson = prefs.getStringList('memories');
      if (memoriesJson == null) {
        return [];
      }
      List<Memory> memories = memoriesJson.map((memoryJson) {
        return Memory.fromMap(json.decode(memoryJson));
      }).toList();
      return memories;
    } catch (e) {
      print("Error retrieving memories: $e");
      throw Exception("Failed to retrieve memories: $e");
    }
  }

  // Clear all saved memories from SharedPreferences
  static Future<void> clearMemories() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('memories');
    } catch (e) {
      print("Error clearing memories: $e");
      throw Exception("Failed to clear memories: $e");
    }
  }

  // Set login status
  static Future<void> setLoginStatus(bool isLoggedIn) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', isLoggedIn);
    } catch (e) {
      print("Error setting login status: $e");
      throw Exception("Failed to set login status: $e");
    }
  }

  // Check login status
  static Future<bool> checkLoginStatus() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isLoggedIn') ?? false;
    } catch (e) {
      print("Error checking login status: $e");
      throw Exception("Failed to check login status: $e");
    }
  }

  // Load user profile (name and email)
  static Future<Map<String, String>> loadProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return {
        'name': prefs.getString('profile_name') ?? '',
        'email': prefs.getString('profile_email') ?? '',
      };
    } catch (e) {
      print("Error loading profile: $e");
      throw Exception("Failed to load profile: $e");
    }
  }

  // Save user profile (name and email)
  static Future<void> saveProfile(String name, String email) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_name', name);
      await prefs.setString('profile_email', email);
    } catch (e) {
      print("Error saving profile: $e");
      throw Exception("Failed to save profile: $e");
    }
  }

  // Delete user profile
  static Future<void> deleteProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('profile_name');
      await prefs.remove('profile_email');
    } catch (e) {
      print("Error deleting profile: $e");
      throw Exception("Failed to delete profile: $e");
    }
  }

  // Logout: Clear login status, memories, and profile
  static Future<void> logout() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('memories');
      await prefs.remove('profile_name');
      await prefs.remove('profile_email');
    } catch (e) {
      print("Error during logout: $e");
      throw Exception("Failed to logout: $e");
    }
  }
}
