import 'package:ecomm/exceptions/auth_exception.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  static const _url ='https://identitytoolkit.googleapis.com/v1/accounts:';
  static const _keyUrlSegment = '?key=AIzaSyDUe0bor3TNIL0Nd4bXvwbAMjzNXn06CD0';

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = urlSegment = '$_url$urlSegment$_keyUrlSegment';
    print(url);
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    final body = jsonDecode(response.body);
    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }
  
  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
