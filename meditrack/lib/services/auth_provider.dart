import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<bool> signup(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('user')) return false;

    User newUser = User(username: username, password: password);
    await prefs.setString('user', json.encode(newUser.toMap()));
    _user = newUser;
    notifyListeners();
    return true;
  }

  Future<bool> login(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user')) return false;

    String? userData = prefs.getString('user');
    if (userData == null) return false;

    User storedUser = User.fromMap(Map<String, String>.from(json.decode(userData)));

    if (storedUser.username == username && storedUser.password == password) {
      _user = storedUser;
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }
}