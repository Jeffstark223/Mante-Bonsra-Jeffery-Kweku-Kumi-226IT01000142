import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _usersKey = "users";
  static const String _currentUserKey = "current_user";

  // Save all users
  static Future<void> saveUsers(Map<String, String> users) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_usersKey, jsonEncode(users));
  }

  // Get all users
  static Future<Map<String, String>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_usersKey);

    if (data == null) return {};
    return Map<String, String>.from(jsonDecode(data));
  }

  // Save logged-in user
  static Future<void> saveCurrentUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_currentUserKey, username);
  }

  // Get logged-in user
  static Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  // Logout
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_currentUserKey);
  }
}