import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, String> _users = {};
  String? _currentUser;
  bool _isLoading = true;

  AuthProvider() {
    _loadData();
  }

  bool get isLoggedIn => _currentUser != null;
  String? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // 🔄 LOAD DATA ON START
  Future<void> _loadData() async {
    _users = await StorageService.getUsers();
    _currentUser = await StorageService.getCurrentUser();
    _isLoading = false;
    notifyListeners();
  }

  // 🔐 SIGNUP
  Future<bool> signup(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (_users.containsKey(username)) {
      return false;
    }

    _users[username] = password;

    await StorageService.saveUsers(_users);
    await StorageService.saveCurrentUser(username);

    _currentUser = username;
    notifyListeners();
    return true;
  }

  // 🔑 LOGIN
  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (_users[username] == password) {
      _currentUser = username;
      await StorageService.saveCurrentUser(username);
      notifyListeners();
      return true;
    }

    return false;
  }

  // 🚪 LOGOUT
  Future<void> logout() async {
    _currentUser = null;
    await StorageService.clearUser();
    notifyListeners();
  }
}