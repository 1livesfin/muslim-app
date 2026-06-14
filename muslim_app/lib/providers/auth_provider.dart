import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUser {
  String name;
  String email;
  String photoUrl;

  LocalUser({
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  factory LocalUser.fromMap(Map<String, dynamic> map) {
    return LocalUser(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }
}

class AuthProvider extends ChangeNotifier {
  LocalUser? _currentUser;

  AuthProvider() {
    _loadUser();
  }

  LocalUser? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('current_user');
    if (userStr != null) {
      _currentUser = LocalUser.fromMap(json.decode(userStr));
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    // Mock login logic
    final prefs = await SharedPreferences.getInstance();
    _currentUser = LocalUser(
      name: 'Hamba Allah',
      email: email,
      photoUrl: '',
    );
    await prefs.setString('current_user', json.encode(_currentUser!.toMap()));
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    // Mock register logic
    final prefs = await SharedPreferences.getInstance();
    _currentUser = LocalUser(
      name: name,
      email: email,
      photoUrl: '',
    );
    await prefs.setString('current_user', json.encode(_currentUser!.toMap()));
    notifyListeners();
  }

  Future<void> updateProfile(String name, String photoUrl) async {
    if (_currentUser == null) return;
    
    _currentUser!.name = name;
    if (photoUrl.isNotEmpty) {
      _currentUser!.photoUrl = photoUrl;
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', json.encode(_currentUser!.toMap()));
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    _currentUser = null;
    notifyListeners();
  }
}
