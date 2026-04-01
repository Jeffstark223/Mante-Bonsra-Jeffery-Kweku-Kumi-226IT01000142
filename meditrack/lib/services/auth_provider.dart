import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // Temporary in-memory user storage
  final Map<String, String> _users = {};

  String? _currentUser;

  // ── LOGIN ─────────────────────────────────────────────
  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate loading

    if (_users.containsKey(username) &&
        _users[username] == password) {
      _currentUser = username;
      notifyListeners();
      return true;
    }
    return false;
  }

  // ── SIGNUP ────────────────────────────────────────────
  Future<bool> signup(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate loading

    if (_users.containsKey(username)) {
      return false; // user already exists
    }

    _users[username] = password;
    _currentUser = username;
    notifyListeners();
    return true;
  }

  // ── LOGOUT ────────────────────────────────────────────
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // ── GET CURRENT USER ──────────────────────────────────
  String? get currentUser => _currentUser;

  // ── CHECK IF LOGGED IN ────────────────────────────────
  bool get isLoggedIn => _currentUser != null;
}