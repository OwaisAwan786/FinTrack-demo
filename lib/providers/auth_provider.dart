import 'package:flutter/material.dart';

// Demo Auth Provider
class AuthProvider with ChangeNotifier {
  bool _isDemoLoggedIn = false;
  bool _isLoading = false;

  bool get isAuthenticated => _isDemoLoggedIn;
  bool get isLoading => _isLoading;

  Future<bool> checkAuthState() async {
    await Future.delayed(const Duration(seconds: 2));
    return _isDemoLoggedIn;
  }

  Future<void> signUp(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1)); 
    _isDemoLoggedIn = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    _isDemoLoggedIn = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isDemoLoggedIn = false;
    notifyListeners();
  }
}
