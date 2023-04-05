import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../configs.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class AuthState extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  String? _token;
  String? get token => _token;

  bool get isLoggedIn => _currentUser != null;

  Future<User?> login(String username, String password) async {
    final loginResponse = await http.post(
      Uri.parse('${Configs.baseUrl}/auth/login'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );
    if (loginResponse.statusCode == HttpStatus.ok) {
      _token = json.decode(loginResponse.body)['token'];
      final userResponse = await http.get(
        Uri.parse('${Configs.baseUrl}/users/me'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
      if (userResponse.statusCode == HttpStatus.ok) {
        _currentUser = User.fromJson(json.decode(userResponse.body));
        notifyListeners();
        return _currentUser;
      }
    }
    logout();
    return null;
  }

  void logout() {
    _currentUser = null;
    _token = null;
    notifyListeners();
  }

  Future<User?> signin(String username, String password) async {
    final registerResponse = await http.post(
      Uri.parse('${Configs.baseUrl}/auth/signup'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (registerResponse.statusCode == HttpStatus.created) {
      login(username, password);
      notifyListeners();
      return _currentUser;
    }

    return null;
  }
}
