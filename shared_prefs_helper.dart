import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:momento/models/memory.dart';

class SharedPrefsHelper {
  static const String _memoriesKey = 'memories';
  static const String _loginStatusKey = 'isLoggedIn';
  static const String _profileNameKey = 'profile_name';
  static const String _profileEmailKey = 'profile_email';

  static Future<SharedPreferences> _getPrefs() =>
      SharedPreferences.getInstance();

  static Future<void> saveMemories(List<Memory> memories) async {
    try {
      final prefs = await _getPrefs();
      final List<String> memoriesJson =
          memories.map((m) => json.encode(m.toMap())).toList();
      await prefs.setStringList(_memoriesKey, memoriesJson);
      print('Memories saved: $memoriesJson'); // Debug log
    } catch (e) {
      print("Error saving memories: $e");
      rethrow;
    }
  }

  static Future<List<Memory>> getMemories() async {
    try {
      final prefs = await _getPrefs();
      final List<String>? memoryList = prefs.getStringList(_memoriesKey);
      print('Memories loaded: $memoryList'); // Debug log
      if (memoryList == null || memoryList.isEmpty) return [];
      return memoryList
          .map((jsonStr) => Memory.fromMap(json.decode(jsonStr)))
          .toList();
    } catch (e) {
      print("Error retrieving memories: $e");
      return []; // Return empty list on error to avoid crashes
    }
  }

  static Future<void> clearMemories() async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove(_memoriesKey);
      print('Memories cleared'); // Debug log
    } catch (e) {
      print("Error clearing memories: $e");
      rethrow;
    }
  }

  static Future<void> setLoginStatus(bool isLoggedIn) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setBool(_loginStatusKey, isLoggedIn);
      print('Login status set: $isLoggedIn'); // Debug log
    } catch (e) {
      print("Error setting login status: $e");
      rethrow;
    }
  }

  static Future<bool> checkLoginStatus() async {
    try {
      final prefs = await _getPrefs();
      final status = prefs.getBool(_loginStatusKey) ?? false;
      print('Login status checked: $status'); // Debug log
      return status;
    } catch (e) {
      print("Error checking login status: $e");
      return false;
    }
  }

  static Future<Map<String, String>> loadProfile() async {
    try {
      final prefs = await _getPrefs();
      final profile = {
        'name': prefs.getString(_profileNameKey) ?? '',
        'email': prefs.getString(_profileEmailKey) ?? '',
      };
      print('Profile loaded: $profile'); // Debug log
      return profile;
    } catch (e) {
      print("Error loading profile: $e");
      return {'name': '', 'email': ''};
    }
  }

  static Future<void> saveProfile(String name, String email) async {
    try {
      final prefs = await _getPrefs();
      await prefs.setString(_profileNameKey, name);
      await prefs.setString(_profileEmailKey, email);
      print('Profile saved: name=$name, email=$email'); // Debug log
    } catch (e) {
      print("Error saving profile: $e");
      rethrow;
    }
  }

  static Future<void> deleteProfile() async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove(_profileNameKey);
      await prefs.remove(_profileEmailKey);
      print('Profile deleted'); // Debug log
    } catch (e) {
      print("Error deleting profile: $e");
      rethrow;
    }
  }

  static Future<bool> logout() async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove(_loginStatusKey);
      await prefs.remove(_memoriesKey);
      await prefs.remove(_profileNameKey);
      await prefs.remove(_profileEmailKey);
      print('Logged out successfully'); // Debug log
      return true;
    } catch (e) {
      print("Error during logout: $e");
      return false;
    }
  }
}
